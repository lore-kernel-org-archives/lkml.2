Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2BQWEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:04:22 -0500
Received: from smtprelay.restena.lu ([158.64.1.62]:59741 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2BQWEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:04:15 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Feb 2012 17:04:14 EST
Date: Fri, 17 Feb 2012 22:57:08 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>, Egmont Koblinger <egmont@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Data corruption when pasting large data to terminal
Message-ID: <20120217225708.0f31f2ac@neptune.home>
In-Reply-To: <20120217192825.GE2707@elf.ucw.cz>
References: <CAGWcZkJs2uQHM=7wmf1JOLmUeS3Mxo5L4arMuMQSez1mvJLKQA@mail.gmail.com>
	<CAGWcZkKV1vc47zB_d0e+Q3+XG08mDt6TfzQ3d0p4=wswKN3ePg@mail.gmail.com>
	<20120215233002.GB20816@kroah.com>
	<CAGWcZkJHCRppjONbHuNop2r2X=n7efK94dQMXrA2=0Ou39bOAg@mail.gmail.com>
	<20120216005437.GA22858@kroah.com>
	<20120217192825.GE2707@elf.ucw.cz>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/W/gmJd+FZFG1j5K6iWxXySy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/W/gmJd+FZFG1j5K6iWxXySy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On Fri, 17 February 2012 Pavel Machek <pavel@ucw.cz> wrote:
> > > Sorry, I didn't emphasize the point that makes me suspect it's a kern=
el issue:
> > >=20
> > > - strace reveals that the terminal emulator writes the correct data
> > > into /dev/ptmx, and the kernel reports no short writes(!), all the
> > > write(..., ..., 68) calls actually return 68 (the length of the
> > > example file's lines incl. newline; I'm naively assuming I can trust
> > > strace here.)
> > > - strace reveals that the receiving application (bash) doesn't receive
> > > all the data from /dev/pts/N.
> > > - so: the data gets lost after writing to /dev/ptmx, but before
> > > reading it out from /dev/pts/N.
> >=20
> > Which it will, if the reader doesn't read fast enough, right?  Is the
> > data somewhere guaranteed to never "overrun" the buffer?  If so, how do
> > we handle not just running out of memory?
>=20
> Start blocking the writer?

I did quickly write a small test program (attached). It forks a reader child
and sends data over to it, at the end both write down their copy of the buf=
fer
to a /tmp/ptmx_{in,out}.txt file for manual comparing results (in addition
to basic output of mismatch start line)

=46rom the time it took the writer to write larger buffers (as seen using str=
ace)
it seems there *is* some kind of blocking, but it's not blocking long enough
or unblocking too early if the reader does not keep up.


For quick and dirty testing of effects of buffer sizes, tune "rsz", "wsz"
and "line" in main() as well as total size with BUFF_SZ define.


The effects for me are that writer writes all data but reader never sees ta=
il
of written data (how much is being seen seems variable, probably matter of
scheduling, frequency scaling and similar racing factors).

My test system is single-core uniprocessor centrino laptop (32bit x86) with
3.2.5 kernel.

Bruno

--MP_/W/gmJd+FZFG1j5K6iWxXySy
Content-Type: text/x-csrc
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=ptmx.c

#define _XOPEN_SOURCE 700
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <sys/wait.h>

#define BUFF_SZ (4096*64)

void write_buffer(const char *buff, size_t buff_sz, const char *fname) {
	int fd =3D open(fname, O_CREAT | O_WRONLY | O_TRUNC, 0664);
	size_t n =3D 0;
	ssize_t r;
	if (!fd) {
		fprintf(stderr, "Failed to open(3) %s: %s\n", fname, strerror(errno));
		return;
	}

	do {
		r =3D write(fd, buff + n, buff_sz - n);
		if (r =3D=3D -1) {
			if (errno =3D=3D EAGAIN || errno =3D=3D EWOULDBLOCK || errno =3D=3D EINT=
R)
				continue;
			fprintf(stderr, "Failed to write(2): %s\n", strerror(errno));
			return;
		} else if (r =3D=3D 0) {
			break;
		} else {
			n +=3D r;
		}
	} while (n < buff_sz);
	close(fd);
}

void ptmx_slave_test(int pty, const char *line, size_t rsz) {
	char *buff =3D malloc(BUFF_SZ);
	size_t n =3D 0, nn;
	ssize_t r;
	int l, bad;
	struct timespec slen;

	if (!buff) {
		fprintf(stderr, "Failed to malloc(3): %s\n", strerror(errno));
		return;
	}

	do {
		r =3D read(pty, buff + n, rsz + n > BUFF_SZ ? BUFF_SZ - n : rsz);
		if (r =3D=3D -1) {
			if (errno =3D=3D EAGAIN || errno =3D=3D EWOULDBLOCK || errno =3D=3D EINT=
R)
				continue;
			fprintf(stderr, "Failed to read(2): %s\n", strerror(errno));
			return;
		} else if (r =3D=3D 0) {
			if (n < BUFF_SZ)
				fprintf(stderr, "Read %zu bytes, expected %zu!\n", n, BUFF_SZ);
			break;
		} else {
			n +=3D r;
		}
		memset(&slen, 0, sizeof(slen));
		nanosleep(&slen, NULL);
	} while (n < BUFF_SZ);
	nn =3D n;

	/* check buffer if it matches expected value... */
	r =3D strlen(line);
	l =3D 0;
	bad =3D 0;
	for (n =3D 0; n < BUFF_SZ; n +=3D r+1) {
		l++;
		if (memcmp(buff + n, line, n + r < BUFF_SZ ? r : BUFF_SZ - n) !=3D 0) {
			// TODO: determine position of breakage!
			fprintf(stderr, "Line data mismatch for line %d!\n", l);
			bad =3D 1;
			break;
		}
		if (n + r + 1 < BUFF_SZ && buff[n+r] !=3D '\n') {
			fprintf(stderr, "Expecting '\\n' at end of line %d, but found 0x%hhx\n",=
 l, buff[n+r]);
			bad =3D 1;
			break;
		}
	}

//	fprintf(stderr, "Buffer seen by slave is:\n");
//	fwrite(buff, BUFF_SZ, 1, stdout);
	if (bad)
		write_buffer(buff, nn, "/tmp/ptmx_out.txt");
}

void ptmx_master_test(int pty, const char *line, size_t wsz) {
	char *buff =3D malloc(BUFF_SZ);
	size_t n =3D 0;
	ssize_t r;

	if (!buff) {
		fprintf(stderr, "Failed to malloc(3): %s\n", strerror(errno));
		return;
	}

	/* initialize buffer */
	r =3D strlen(line);
	for (n =3D 0; n < BUFF_SZ; n +=3D r+1) {
		memcpy(buff + n, line, n + r < BUFF_SZ ? r : BUFF_SZ - n);
		if (n + r + 1 < BUFF_SZ)
			buff[n+r] =3D '\n';
	}

	n =3D 0;
	do {
		r =3D write(pty, buff + n, wsz + n > BUFF_SZ ? BUFF_SZ - n : wsz);
		if (r =3D=3D -1) {
			if (errno =3D=3D EAGAIN || errno =3D=3D EWOULDBLOCK || errno =3D=3D EINT=
R)
				continue;
			fprintf(stderr, "Failed to write(2): %s\n", strerror(errno));
			return;
		} else if (r =3D=3D 0) {
			break;
		} else {
			n +=3D r;
		}
	} while (n < BUFF_SZ);
	close(pty);
	write_buffer(buff, BUFF_SZ, "/tmp/ptmx_in.txt");
}

int main() {
	const char *line =3D "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOP=
QRSTUVWXYZ";
	const char *ptsdname =3D NULL;
	int pty, pid;
	size_t rsz =3D 128, wsz =3D 1024;


	pty =3D open("/dev/ptmx", O_RDWR | O_CLOEXEC);
	if (pty =3D=3D -1) {
		fprintf(stderr, "Failed to open(3) /dev/ptmx: %s\n", strerror(errno));
		return 1;
	}

	ptsdname =3D ptsname(pty);
	if (!ptsdname) {
		fprintf(stderr, "Failed to ptsname(3): %s\n", strerror(errno));
		close(pty);
		return 1;
	}

	if (grantpt(pty) =3D=3D -1) {
		fprintf(stderr, "Failed to grantpty(3): %s\n", strerror(errno));
		close(pty);
		return 1;
	}

	if (unlockpt(pty) =3D=3D -1) {
		fprintf(stderr, "Failed to unlockpt(3): %s\n", strerror(errno));
		close(pty);
		return 1;
	}

	pid =3D fork();
	if (pid =3D=3D -1) {
		fprintf(stderr, "Failed to fork(3): %s\n", strerror(errno));
		close(pty);
		return 1;
	} else if (pid =3D=3D 0) {
		close(pty);

		pty =3D open(ptsdname, O_RDWR | O_CLOEXEC);
		if (pty =3D=3D -1) {
			fprintf(stderr, "Failed to open(3) %s: %s\n", ptsdname, strerror(errno));
			return 1;
		}

		ptmx_slave_test(pty, line, rsz);
		close(pty);
		return 0;
	} else {
		int s;
		ptmx_master_test(pty, line, wsz);

		if (waitpid(pid, &s, 0) =3D=3D -1) {
			fprintf(stderr, "Failed to waitpid(2) for %d: %s\n", pid, strerror(errno=
));
			return 1;
		}
		if (WIFEXITED(s) && WEXITSTATUS(s) =3D=3D 0)
			return 0;
		if (WIFEXITED(s))
			fprintf(stderr, "Child exited with %d\n", WEXITSTATUS(s));
		else if (WIFSIGNALED(s))
			fprintf(stderr, "Child died with signal %d\n", WTERMSIG(s));
		else
			fprintf(stderr, "Child terminated in an unknown way with status %d\n", s=
);
		return 1;
	}
}

--MP_/W/gmJd+FZFG1j5K6iWxXySy--
