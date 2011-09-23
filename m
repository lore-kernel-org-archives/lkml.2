Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab1IWTwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 15:52:25 -0400
Received: from gateway03.websitewelcome.com ([69.93.139.30]:49409 "HELO
	gateway03.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751784Ab1IWTwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 15:52:23 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Sep 2011 15:52:23 EDT
X-Spam-Flag2999: NO
X-Spam-Level2999: 
X-Spam-Status2999: "No, score=-1.9 required=5.0 tests=BAYES_00 autolearn=ham
	version=3.3.1
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=taghos.com.br;
	h=Received:Date:From:To:Subject:Message-ID:Organization:X-Mailer:Mime-Version:Content-Type:X-BWhitelist:X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:X-Email-Count:X-Source-Cap;
	b=bwR0vC/n89UsJS5wuGPPOnML/C88ouc3h1xnUD6TWSinBfHOu67p8zMptz4E27IGVJ5/wP/q0F2IiSjgnSOXxQDRmsWmZifQhUAWq2o8qQNf6GQ1GKobGp0PSplJuW1x;
Date: Fri, 23 Sep 2011 16:42:26 -0300
From: Ricardo Nabinger Sanchez <rnsanchez@taghos.com.br>
To: linux-kernel@vger.kernel.org
Subject: write() on pipe blocking due to in-page fragmentation?
Message-ID: <20110923164226.211a76dc@darkmoor.lan.box>
Organization: Taghos - http://www.taghos.com.br/
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Hfj2tP9=BOprZ_r_ZD6f8OI"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator1481.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - taghos.com.br
X-BWhitelist: no
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (darkmoor.lan.box) [201.21.234.175]:30838
X-Source-Auth: rnsanchez@taghos.com.br
X-Email-Count: 8
X-Source-Cap: dGFnaG9zO3RhZ2hvcztnYXRvcjE0ODEuaG9zdGdhdG9yLmNvbQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/Hfj2tP9=BOprZ_r_ZD6f8OI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

The simple program attached allocates a pipe, perform a number of
writes in it in order to fill the pipe, and then reads that data to
empty the pipe.  The argument is used to determine how much data to
write per write iteration.

Values that are power of 2 up to PIPE_BUF work without any issues.
Other values may cause the write() call to block.

For example, on a 32-bit machine:

(gdb) r 3
Starting program: /home/rnsanchez/Taghos/sshfs/pipe-test/single32 3
Pipe: 00000/32
  write: 65520..65523/65536^C
Program received signal SIGINT, Interrupt.
0xb7f2de5e in __write_nocancel () from /lib/libc.so.6
(gdb) bt
#0  0xb7f2de5e in __write_nocancel () from /lib/libc.so.6
#1  0x08048705 in main ()

Similar behavior on a 64-bit machine, different version of both Linux
kernel and glibc.

Intuitively, it seems that pages in the pipe are getting fragmented,
and eventually it will reach the limit of 16 pages and, if the data is
not consumed, will cause writers to block --- even though the data
would fit nicely otherwise.

Is this understanding correct?  If so, is it something that should be
fixed in the Linux kernel?

Or should the application ensure that data written to the pipe will be
done carefully as to not block a writer?

Thank you in advance for your attention.

Regards

-- 
Ricardo Nabinger Sanchez             http://www.taghos.com.br/

--MP_/Hfj2tP9=BOprZ_r_ZD6f8OI
Content-Type: text/x-csrc
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=single.c

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

#define PIPES	1
#define BUFLEN	65536

struct pp {
	int		pfd[2];
};

int main(int argc, char *argv[]) {
	unsigned int	i;
	unsigned int	len;
	int		wlen;
	struct pp	*pvet = calloc(PIPES, sizeof(struct pp));
	char		*buf = malloc(BUFLEN);

	if (argc != 2)
		exit(1);

	wlen = atoi(argv[1]);
	if (wlen <= 0 || wlen > BUFLEN)
		exit(2);

	for (i = 0; i < BUFLEN; i++)
		buf[i] = 'o';

	// Create.
	for (i = 0; i < PIPES; i++) {
		if (pipe(pvet[i].pfd) != 0) {
			perror("pipe");
			abort();
		}
	}

	// Fill pipes.
	for (i = 0; i < PIPES; i++) {
		fprintf(stderr, "Pipe: %05u/%d\n", i, PIPES);
		for (len = 0; len < BUFLEN; len += wlen) {
			fprintf(stderr, "\r  write: %05u..%u/%d", len,
					len+(unsigned)wlen, BUFLEN);
			if (write(pvet[i].pfd[1], &buf[len], wlen) <= 0) {
				perror("write");
				abort();
			}
		}
		fprintf(stderr, "\n");
	}

	// Consume data from pipes.
	for (i = 0; i < PIPES; i++) {
		fprintf(stderr, "Pipe: %05u/%d\n", i, PIPES);
		if (read(pvet[i].pfd[0], buf, BUFLEN) != BUFLEN) {
			perror("read");
			abort();
		}
	}

	exit(0);
}

--MP_/Hfj2tP9=BOprZ_r_ZD6f8OI--
