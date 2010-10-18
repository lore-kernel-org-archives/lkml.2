Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471Ab0JRWrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 18:47:55 -0400
Received: from atreides.gradator.net ([212.85.155.42]:47512 "EHLO
	atreides.gradator.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933450Ab0JRWrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 18:47:53 -0400
X-Greylist: delayed 730 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Oct 2010 18:47:52 EDT
Date: Tue, 19 Oct 2010 00:35:40 +0200
From: Sylvain Rochet <gradator@gradator.net>
To: linux-kernel@vger.kernel.org
Message-ID: <20101018223540.GA20730@gradator.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: gradator@atreides.gradator.net
Subject: PROBLEM: 2.6.35.7 Inotify events missing
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:20:07 +0000)
X-SA-Exim-Scanned: Yes (on atreides.gradator.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I write a tool that keep in sync one source (master) to multiple=20
targets (slaves) to provide always up to date mirrors in order to=20
distribute static content at different locations.

That was working fine on 2.6.26.5 kernel, except bugs that are my=20
fault and which are fixed the way the time goes.

A day I upgraded to 2.6.33.5, then 2.6.33.7, finally to 2.6.35.7, and I=20
always end up with the same ending, it seems inotify can miss some VFS=20
events from time to time.

I wrote a simple tool which is a cleaned code of the first=20
explained master process that only display received inotify events and=20
with the recursion stuff that keep all directories watched.


First, this is not due to queue limit depth, limits are way over=20
requirements. I don't received IN_Q_OVERFLOW event either.

$ cat /proc/sys/fs/inotify/max_{queued_events,user_instances,user_watches}
524288
128
1000000


That may help, files and FS tree are modified over NFS.


Here is what I got:

# stat ./xnlegacies/statique/wiki/cache/d/db303d42803e58bb5f73467291c9a863.=
xhtml
  File: `./xnlegacies/statique/wiki/cache/d/db303d42803e58bb5f73467291c9a86=
3.xhtml'
  Size: 11696           Blocks: 24         IO Block: 4096   regular file
Device: 90ah/2314d      Inode: 144835214   Links: 1
Access: (0644/-rw-r--r--)  Uid: (20981/ UNKNOWN)   Gid: (26734/ UNKNOWN)
Access: 2010-03-18 14:04:59.000000000 +0000
Modify: 2010-10-14 06:44:27.000000000 +0000
Change: 2010-10-14 06:44:27.000000000 +0000

# stat ./xnlegacies/statique/wiki/cache/d/db303d42803e58bb5f73467291c9a863.i
  File: `./xnlegacies/statique/wiki/cache/d/db303d42803e58bb5f73467291c9a86=
3.i'
  Size: 30575           Blocks: 64         IO Block: 4096   regular file
Device: 90ah/2314d      Inode: 144835393   Links: 1
Access: (0644/-rw-r--r--)  Uid: (20981/ UNKNOWN)   Gid: (26734/ UNKNOWN)
Access: 2010-03-18 14:04:59.000000000 +0000
Modify: 2010-10-14 06:44:26.000000000 +0000
Change: 2010-10-14 06:44:26.000000000 +0000

So, here is two files that were modified at about 2010-10-14 06:44:26.

And now is what I got in the event log of my inotify logger:

# grep db303d42803e58bb5f73467291c9a863 debugevents=20
2010/10/12 20:06:48 1286914008:604497: wd=3D16623 mask=3D2 cookie=3D0 len=
=3D48 name=3Ddb303d42803e58bb5f73467291c9a863.i pathname=3D./xnlegacies/sta=
tique/wiki/cache/d/db303d42803e58bb5f73467291c9a863.i
2010/10/12 20:06:48 1286914008:605215: wd=3D16623 mask=3D2 cookie=3D0 len=
=3D48 name=3Ddb303d42803e58bb5f73467291c9a863.i pathname=3D./xnlegacies/sta=
tique/wiki/cache/d/db303d42803e58bb5f73467291c9a863.i
2010/10/12 20:06:48 1286914008:686793: wd=3D16623 mask=3D2 cookie=3D0 len=
=3D48 name=3Ddb303d42803e58bb5f73467291c9a863.xhtml pathname=3D./xnlegacies=
/statique/wiki/cache/d/db303d42803e58bb5f73467291c9a863.xhtml
2010/10/12 20:06:48 1286914008:687372: wd=3D16623 mask=3D2 cookie=3D0 len=
=3D48 name=3Ddb303d42803e58bb5f73467291c9a863.xhtml pathname=3D./xnlegacies=
/statique/wiki/cache/d/db303d42803e58bb5f73467291c9a863.xhtml

I did not receive events about the modification of those files at=20
2010-10-14 06:44, but we received previous events 2 days ago



Here is another example:

# stat ./synfig/forums/files/thumb_5_ec61d61306649e73f2549775c2ee3e1c  =20
  File: `./synfig/forums/files/thumb_5_ec61d61306649e73f2549775c2ee3e1c'
  Size: 23886           Blocks: 48         IO Block: 4096   regular file
Device: 90ah/2314d      Inode: 178390723   Links: 1
Access: (0664/-rw-rw-r--)  Uid: (15653/ UNKNOWN)   Gid: (27452/ UNKNOWN)
Access: 2010-10-15 05:28:35.000000000 +0000
Modify: 2010-10-15 05:28:35.000000000 +0000
Change: 2010-10-15 05:28:35.000000000 +0000

Here is a file that was modified at 05:28:35.


# grep thumb_5_ec61d61306649e73f2549775c2ee3e1c debugevents=20
2010/10/15 05:28:35 1287120515:058819: wd=3D16079 mask=3D100 cookie=3D0 len=
=3D48 name=3Dthumb_5_ec61d61306649e73f2549775c2ee3e1c pathname=3D./synfig/f=
orums/files/thumb_5_ec61d61306649e73f2549775c2ee3e1c

I received an event that the file was created, at the time of the event=20
the file was 0 byte length, the file was then filled, but we did not=20
received events about the fact that the file was modified.


If I try to do the same, I get IN_CREATE, then IN_MODIFY,

# echo "test" > hFq0gUrK1EGwoT2pnpCO

# grep hFq0gUrK1EGwoT2pnpCO debugevents=20
2010/10/18 19:40:59 1287430859:712722: wd=3D1 mask=3D100 cookie=3D0 len=3D3=
2 name=3DhFq0gUrK1EGwoT2pnpCO pathname=3D./hFq0gUrK1EGwoT2pnpCO
2010/10/18 19:40:59 1287430859:713543: wd=3D1 mask=3D2 cookie=3D0 len=3D32 =
name=3DhFq0gUrK1EGwoT2pnpCO pathname=3D./hFq0gUrK1EGwoT2pnpCO



I attached my quick-n-dirty inotify logger. Source code of the full=20
replication software is available here[1], if it helps.


I can provide as many information as possible and I am willing to do so ;)

Regards,
Sylvain



[1] svn://svn.tuxfamily.org/svnroot/vhffs4/vhffs/trunk/vhffs-fssync/

--d6Gm4EdcadzBjdND
Content-Type: text/x-csrc; charset=iso-8859-1
Content-Disposition: attachment; filename="vhffsfssync_log.c"
Content-Transfer-Encoding: quoted-printable

/*
 *  VHFFSFSSYNC: Scalable file system replication over TCP
 *
 *  Copyright 2008  Sylvain Rochet <gradator@gradator.net>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

#ifndef __linux__
#error This software is only running on Linux-based OS, bye!
#endif

#define _FILE_OFFSET_BITS 64

#define DEBUG_NET 1
#define DEBUG_INOTIFY 1
#define DEBUG_EVENTS 1
//#define NDEBUG

#include <assert.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <fcntl.h>
#include <dirent.h>
#include <string.h>
#include <errno.h>
#include <sys/inotify.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <glib.h>
#include <sys/select.h>
#include <signal.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <sys/sendfile.h>
#include <getopt.h>


char vhffsfssync_debugtsstr[256];

char *vhffsfssync_debugts() {
	time_t t;
	struct tm *tmp;
	struct timeval tv;

	t =3D time(NULL);
	tmp =3D localtime(&t);
	gettimeofday(&tv, NULL);

	strftime(vhffsfssync_debugtsstr, 200, "%Y/%m/%d %H:%M:%S ", tmp);
	sprintf(vhffsfssync_debugtsstr+strlen(vhffsfssync_debugtsstr), "%lld:%.6ld=
" , (long long)tv.tv_sec, (long)tv.tv_usec );

	return vhffsfssync_debugtsstr;
}


/* -- inotify stuff -- */

#define VHFFSFSSYNC_BUF_LEN 4096
//#define VHFFSFSSYNC_WATCH_MASK IN_ATTRIB|IN_CREATE|IN_DELETE|IN_CLOSE_WRI=
TE|IN_MODIFY|IN_MOVED_FROM|IN_MOVED_TO|IN_DONT_FOLLOW|IN_ONLYDIR
#define VHFFSFSSYNC_WATCH_MASK IN_ATTRIB|IN_CREATE|IN_DELETE|IN_MODIFY|IN_M=
OVED_FROM|IN_MOVED_TO|IN_DONT_FOLLOW|IN_ONLYDIR
// Not used yet: IN_DELETE_SELF, IN_MOVE_SELF
// Will never be used: IN_ACCESS, IN_OPEN, IN_CLOSE_NOWRITE

// each monitor entry is associated with a path, we need to keep it to comp=
ute the path
//char **vhffsfssync_wd_to_watch =3D NULL;
//int vhffsfssync_wd_to_watch_len =3D 0;  // number of allocated paths
GHashTable *vhffsfssync_wd_to_watch;


typedef struct vhffsfssync_watch_ {
	int wd;
	char *dirname;
	struct vhffsfssync_watch_ *parent;
} vhffsfssync_watch;

// return a timestamp in ms (it loops for 100000 sec)
/*inline int vhffsfssync_timestamp()  {
	struct timeval tv;
	gettimeofday(&tv, NULL);
 	return (tv.tv_sec%100000)*1000+tv.tv_usec/1000;
}*/

struct vhffsfssync_cookie {
	uint32_t id;
	vhffsfssync_watch *watch;
	char *filename;
	gboolean isdir;
};
static struct vhffsfssync_cookie vhffsfssync_cookie;

// protos
char *vhffsfssync_pathname(vhffsfssync_watch *watch, const char *filename);
vhffsfssync_watch *vhffsfssync_add_watch(int inotifyfd, vhffsfssync_watch *=
parent, const char *dirname, uint32_t mask);
int vhffsfssync_del_watch(int inotifyfd, vhffsfssync_watch *watch);
vhffsfssync_watch *vhffsfssync_add_watch_recursively(int inotifyfd, vhffsfs=
sync_watch *parent, const char *dirname, uint32_t mask);
int vhffsfssync_manage_event_remove(int inotifyfd, vhffsfssync_watch *watch=
, char *filename);
int vhffsfssync_manage_event_create(int inotifyfd, vhffsfssync_watch *watch=
, char *filename);
int vhffsfssync_manage_event(int inotifyfd, struct inotify_event *event);
int vhffsfssync_fake_events_recursively(int inotifyfd, vhffsfssync_watch *w=
atch);


/* -- inotify stuff -- */

char *vhffsfssync_pathname(vhffsfssync_watch *watch, const char *filename) =
 {

	GString *pathname =3D g_string_sized_new(256);
	char **dirnames, **curnames, **endnames;
	uint32_t a;

	a =3D 16;
	dirnames =3D malloc( a * sizeof(char*) );
	curnames =3D dirnames;
	endnames =3D dirnames+a;

	if(filename) {
		*(curnames++) =3D (char*)filename;
	}

	while(watch) {
		*(curnames++) =3D watch->dirname;
		watch =3D watch->parent;
		if(curnames =3D=3D endnames) {
			a +=3D 16;
			dirnames =3D realloc( dirnames, a * sizeof(char*) );
			curnames =3D dirnames+a-16;
			endnames =3D dirnames+a;
		}
	}

	curnames--;
	g_string_append(pathname, *(curnames--) );
	while( curnames >=3D dirnames ) {
		g_string_append_c(pathname, '/');
		g_string_append(pathname, *(curnames--)  );
	}
	free(dirnames);

	return g_string_free(pathname, FALSE);
}


vhffsfssync_watch *vhffsfssync_add_watch(int inotifyfd, vhffsfssync_watch *=
parent, const char *dirname, uint32_t mask)  {

	int wd;
	char *pathname;
	vhffsfssync_watch *watch;

	pathname =3D vhffsfssync_pathname(parent, dirname);
#if DEBUG_INOTIFY
	printf("%s: t+ %s\n", vhffsfssync_debugts(), pathname);
#endif

	wd =3D inotify_add_watch(inotifyfd, pathname, mask);
	if(wd < 0) {
		if(errno =3D=3D ENOSPC)  {
			fprintf(stdout, "%s: Maximum number of watches reached, consider adding =
more...\n", vhffsfssync_debugts() );
		}
		free(pathname);
		return NULL;
	}

 	if( (watch =3D g_hash_table_lookup(vhffsfssync_wd_to_watch, &wd)) ) {

		// this was already watched, update name and reattach to the new parent
		free(watch->dirname);
		watch->dirname =3D g_strdup(dirname);
		watch->parent =3D parent;

#if DEBUG_INOTIFY
		printf("%s: u+ %d %s\n", vhffsfssync_debugts(), wd, pathname);
#endif
		free(pathname);
		return watch;
	}

	watch =3D malloc(sizeof(vhffsfssync_watch));
	watch->wd =3D wd;
	watch->dirname =3D g_strdup(dirname);
	watch->parent =3D parent;

//	_wd =3D g_new(int, 1);
//	*_wd =3D wd;
	g_hash_table_insert(vhffsfssync_wd_to_watch, &watch->wd, watch);

//	if(wd >=3D vhffsfssync_wd_to_watch_len)  {
//		vhffsfssync_wd_to_watch_len =3D ( (wd >>10) +1) <<10;
//		vhffsfssync_wd_to_watch =3D realloc( vhffsfssync_wd_to_watch, vhffsfssy=
nc_wd_to_watch_len * sizeof(void*) );
//	}
//	vhffsfssync_wd_to_watch[wd] =3D strdup(pathname);
#if DEBUG_INOTIFY
	printf("%s: a+ %d %s\n", vhffsfssync_debugts(), wd, pathname);
#endif
	free(pathname);
	return watch;
}


int vhffsfssync_del_watch(int inotifyfd, vhffsfssync_watch *watch)  {

#if DEBUG_INOTIFY
	char *pathname =3D vhffsfssync_pathname(watch, NULL);
	printf("%s: - %d %s\n", vhffsfssync_debugts(), watch->wd, pathname);
	free(pathname);
#endif
	g_hash_table_remove(vhffsfssync_wd_to_watch, &watch->wd);
	inotify_rm_watch(inotifyfd, watch->wd);
	free(watch->dirname);
	free(watch);
	return 0;
}


vhffsfssync_watch *vhffsfssync_add_watch_recursively(int inotifyfd, vhffsfs=
sync_watch *parent, const char *dirname, uint32_t mask)  {

	vhffsfssync_watch *watch;
	char *pathname;
	DIR *d;

	watch =3D vhffsfssync_add_watch(inotifyfd, parent, dirname, mask);
	if(!watch) return NULL;

	pathname =3D vhffsfssync_pathname(parent, dirname);
	d =3D opendir(pathname);
	free(pathname);
	if(d) {
		struct dirent *dir;
		while( (dir =3D readdir(d)) )  {
			if(dir->d_type =3D=3D DT_DIR && strcmp(dir->d_name, ".") && strcmp(dir->=
d_name, "..") )  {
				vhffsfssync_add_watch_recursively(inotifyfd, watch, dir->d_name, mask);
			}
		}
		closedir(d);
	}

	return watch;
}


int vhffsfssync_manage_event_remove(int inotifyfd, vhffsfssync_watch *watch=
, char *filename)  {
	char *pathname;

	pathname =3D vhffsfssync_pathname(watch, filename);

#if DEBUG_INOTIFY
	printf("%s: =3D=3D> REMOVE %s\n", vhffsfssync_debugts(), pathname);
#endif

	free(pathname);
	return 0;
}


int vhffsfssync_manage_event_create(int inotifyfd, vhffsfssync_watch *watch=
, char *filename)  {
	struct stat st;
	char *pathname;

	pathname =3D vhffsfssync_pathname(watch, filename);

	if(! lstat(pathname, &st) )  {

		if( S_ISREG(st.st_mode) )  {
#if DEBUG_INOTIFY
			printf("%s: =3D=3D> CREATE %s\n", vhffsfssync_debugts(), pathname);
#endif
		}

		else if( S_ISDIR(st.st_mode) )  {
			vhffsfssync_watch *newwatch;
#if DEBUG_INOTIFY
			printf("%s: =3D=3D> MKDIR %s\n", vhffsfssync_debugts(), pathname);
#endif
			newwatch =3D vhffsfssync_add_watch(inotifyfd, watch, filename, VHFFSFSSY=
NC_WATCH_MASK);
			/* there is a short delay between the mkdir() and the add_watch(),
			   we need to send events about the data which have already been written=
 */
			vhffsfssync_fake_events_recursively( inotifyfd, newwatch );
		}

		else if( S_ISLNK(st.st_mode) )  {
			char *linkto;
			int ret;
			linkto =3D malloc(st.st_size +1);
			ret =3D readlink(pathname, linkto, st.st_size);
			if( ret >=3D 0 )  {
				linkto[st.st_size] =3D '\0';
#if DEBUG_INOTIFY
				printf("%s: =3D=3D> SYMLINK %s -> %s\n", vhffsfssync_debugts(), pathnam=
e, linkto);
#endif
			}
			free(linkto);
			if(ret < 0) {
				if(errno =3D=3D ENOENT) {
					// file already disappeared (common for temporary files)
				} else {
					fprintf(stdout, "%s: cannot readlink() '%s': %s\n", vhffsfssync_debugt=
s(), pathname, strerror(errno));
					free(pathname);
					return -1;
				}
			}

		}
		/* we don't need other file types (chr, block, fifo, socket, ...) */
	}
	else {
		if(errno =3D=3D ENOENT) {
			// file already disappeared (common for temporary files)
		} else {
			fprintf(stdout, "%s: cannot lstat() '%s': %s\n", vhffsfssync_debugts(), =
pathname, strerror(errno));
			free(pathname);
			return -1;
		}
	}

	free(pathname);
	return 0;
}


int vhffsfssync_manage_event(int inotifyfd, struct inotify_event *event)  {

	vhffsfssync_watch *watch;
	char *pathname;
#if DEBUG_INOTIFY
	printf("%s: wd=3D%d mask=3D%x cookie=3D%d len=3D%d", vhffsfssync_debugts()=
, event->wd, event->mask, event->cookie, event->len);
	if(event->len > 0) printf(" name=3D%s", event->name);
#endif

	if(event->wd < 0) {
		fprintf(stdout, "\n%s: Maximum number of events reached, some events are =
lost\n", vhffsfssync_debugts() );
		return -1;
	}

	watch =3D g_hash_table_lookup(vhffsfssync_wd_to_watch, &event->wd);
	assert( watch !=3D NULL );

	if(event->len > 0)  {
		pathname =3D vhffsfssync_pathname(watch, event->name);
	} else {
		pathname =3D vhffsfssync_pathname(watch, NULL);
	}

	printf(" pathname=3D%s\n", pathname);

	// this event is not waiting for a cookie, delete file if necessary (IN_MO=
VED_FROM not followed with IN_MOVED_TO)
	if( !(event->mask & IN_MOVED_TO) && vhffsfssync_cookie.id )  {

		vhffsfssync_manage_event_remove(inotifyfd, vhffsfssync_cookie.watch, vhff=
sfssync_cookie.filename);
		vhffsfssync_cookie.id =3D 0;
		free(vhffsfssync_cookie.filename);
	}

	// new mtime, mode, owner, group (and also other stuff like atime, but we =
are not using them)
	if( event->mask & IN_ATTRIB )  {
		struct stat st;
#if DEBUG_INOTIFY
		printf("%s: IN_ATTRIB\n", vhffsfssync_debugts() );
#endif
		if(! lstat(pathname, &st) )  {
	=09
		}
		else {
			if(errno =3D=3D ENOENT) {
				// file already disappeared (common for temporary files)
			} else {
				fprintf(stdout, "%s: cannot lstat() '%s': %s\n", vhffsfssync_debugts(),=
 pathname, strerror(errno));
			}
		}

	// new file, directory, or symlink
	} else if( event->mask & IN_CREATE )  {
#if DEBUG_INOTIFY
		printf("%s: IN_CREATE\n", vhffsfssync_debugts() );
#endif
		vhffsfssync_manage_event_create(inotifyfd, watch, event->name);

	// deleted file, directory or symlink
	} else if( event->mask & IN_DELETE )  {
#if DEBUG_INOTIFY
		printf("%s: IN_DELETE\n", vhffsfssync_debugts() );
#endif
		vhffsfssync_manage_event_remove(inotifyfd, watch, event->name);

	// watch deleted, not used
	} else if( event->mask & IN_DELETE_SELF )  {
#if DEBUG_INOTIFY
		printf("%s: IN_DELETE_SELF\n", vhffsfssync_debugts());
#endif
		// We don't send REMOVE here because the dir can be deleted before the
		// event was added, in this case the add_watch failed to monitor this dir
		// and we'll not receive a IN_DELETE_SELF for it
		//
		// Anyway, a IN_IGNORE event will be sent, IN_DELETE_SELF is only
		// useful for monitored files, that is not used here.

	// file modified
	} else if( event->mask & IN_MODIFY )  {
#if DEBUG_INOTIFY
		printf("%s: IN_MODIFY\n", vhffsfssync_debugts() );
		/* we can send the data here */
		printf("%s: =3D=3D> SEND %s\n", vhffsfssync_debugts(), pathname);
#endif

	// file modified and closed
	} else if( event->mask & IN_CLOSE_WRITE )  {
#if DEBUG_INOTIFY
		printf("%s: IN_CLOSE_WRITE\n", vhffsfssync_debugts() );
		/* we must send the data here */
		printf("%s: =3D=3D> SEND %s\n", vhffsfssync_debugts(), pathname);
#endif

	// watch moved, not used
	} else if( event->mask & IN_MOVE_SELF )  {
#if DEBUG_INOTIFY
		printf("%s: IN_MOVE_SELF\n", vhffsfssync_debugts() );
#endif
		// not needed (we can rely on IN_MOVED_FROM and IN_MOVED_TO)

	// file/symlink/directory moved
	//
	// only from: delete the file/symlink/directory
	// only to: create the file/symlink/directory
	// both: mv the file/symlink/directory
	//
	} else if( event->mask & IN_MOVED_FROM )  {
#if DEBUG_INOTIFY
		printf("%s: IN_MOVED_FROM\n", vhffsfssync_debugts() );
#endif
		// set the cookie
		vhffsfssync_cookie.id =3D event->cookie;
		vhffsfssync_cookie.watch =3D watch;
		vhffsfssync_cookie.filename =3D strdup(event->name);
		vhffsfssync_cookie.isdir =3D !!( event->mask & IN_ISDIR );

	} else if( event->mask & IN_MOVED_TO )  {
#if DEBUG_INOTIFY
		printf("%s: IN_MOVED_TO\n", vhffsfssync_debugts() );
#endif
		// mv
		if(vhffsfssync_cookie.id =3D=3D event->cookie)  {
#if DEBUG_INOTIFY
			char *tmp =3D vhffsfssync_pathname(vhffsfssync_cookie.watch, vhffsfssync=
_cookie.filename);
			printf("%s: =3D=3D> MOVE (%d -> %d) %s -> %s  (used cookie %d)\n", vhffs=
fssync_debugts(), vhffsfssync_cookie.watch->wd, watch->wd, tmp, pathname, v=
hffsfssync_cookie.id);
			free(tmp);
#endif
			if( vhffsfssync_cookie.isdir )  {

				char *frompathname =3D vhffsfssync_pathname(vhffsfssync_cookie.watch, v=
hffsfssync_cookie.filename);
				vhffsfssync_add_watch(inotifyfd, watch, event->name, VHFFSFSSYNC_WATCH_=
MASK);
				free(frompathname);
			}
			else {
				vhffsfssync_manage_event_remove(inotifyfd, vhffsfssync_cookie.watch, vh=
ffsfssync_cookie.filename);
				vhffsfssync_manage_event_create(inotifyfd, watch, event->name);
			}

			vhffsfssync_cookie.id =3D 0;
			free(vhffsfssync_cookie.filename);
		}
		// create
		else  {
			vhffsfssync_manage_event_create(inotifyfd, watch, event->name);
		}

	// watch deleted, clean it
	} else if( event->mask & IN_IGNORED )  {
#if DEBUG_INOTIFY
		printf("%s: IN_IGNORED\n", vhffsfssync_debugts() );
#endif
		vhffsfssync_del_watch(inotifyfd, watch);

	// this event is not handled, this should not happen
	} else {
#if DEBUG_INOTIFY
		printf("%s: OOOOOOOPPPSS!!!!!\n", vhffsfssync_debugts()  );
#endif
	}

	free(pathname);
	return 0;
}


int vhffsfssync_fake_events_recursively(int inotifyfd, vhffsfssync_watch *w=
atch)  {
	DIR *d;
	char *pathname;

	pathname =3D vhffsfssync_pathname(watch, NULL);
	d =3D opendir(pathname);
	free(pathname);

	if(d) {
		struct dirent *dir;
		while( (dir =3D readdir(d)) ) {
			if( strcmp(dir->d_name, ".") && strcmp(dir->d_name, "..") ) {
				// recursivity is done through vhffsfssync_manage_event_create()
				// which calls this function
				vhffsfssync_manage_event_create(inotifyfd, watch, dir->d_name);
			}
		}
		closedir(d);
	}

	return 0;
}


static void usage_exit(int ret_code, char *progname)  {
	printf ("Usage: %s [OPTION]... DIRECTORY\n"
		"Remote synchronous file-copying tool, this is the server (the master)\n\=
n"
		"  -f, --foreground\tDon't daemonise the server, display errors on the co=
nsole\n"
		"  -b, --bind=3DIP\t\tListen to the specified IP address\n"
		"  -p, --port=3DPORT\tListen to this port\n"
		"      --pidfile=3DPATH\tWrite the pid to that file\n"
		"  -h, --help\t\tDisplay this help and exit\n"
		"  -v, --version\t\tOutput version information and exit\n",
		progname);
	exit(ret_code);
}


int main(int argc, char *argv[])  {

	int inotifyfd, flags;
	vhffsfssync_watch *watch;

	char *root =3D NULL;

	struct option long_options[] =3D {
		{ "help", no_argument, NULL, 'h' },
		{ "version", no_argument, NULL, 'v' },
		{ 0, 0, 0, 0 }
	};

	while(1) {
		int option_index =3D 0, c;
		c =3D getopt_long(argc, argv, "hv", long_options, &option_index);
		if(c =3D=3D -1)
			break;

		switch(c) {
			case 'h':
				usage_exit(0, argv[0]);

			case 'v':
#ifdef VERSION
				fputs("vhffsfssync_master " VERSION "\n", stdout);
#else
				fputs("vhffsfssync_master\n", stdout);
#endif
				exit(0);

			case '?':
				/* `getopt_long' already printed an error message. */
				fprintf(stdout,"Try `%s --help' for more information.\n", argv[0]);
				exit(1);

			default:
				abort();
		}
	}

	if(optind !=3D argc-1)
		usage_exit(1, argv[0]);

	root =3D argv[optind++];

	/* chdir() to the filesystem to monitor */
	if(!root) return -1;
	if( root[strlen(root)-1] =3D=3D '/' ) root[strlen(root)-1] =3D '\0';
#if DEBUG_INOTIFY
	printf("%s: Monitoring %s\n", vhffsfssync_debugts(), root);
#endif
	if( chdir(root) < 0 ) {
		fprintf(stdout, "%s: cannot chdir() to %s: %s\n", vhffsfssync_debugts(), =
root, strerror(errno));
		return -1;
	}
	if( chroot(".") < 0 ) {
		fprintf(stdout, "%s: cannot chroot() to %s: %s\n", vhffsfssync_debugts(),=
 root, strerror(errno));
		//return -1;
	}
	root =3D ".";

	/* -- inotify stuff -- */

	vhffsfssync_wd_to_watch =3D g_hash_table_new_full(g_int_hash, g_int_equal,=
 NULL, NULL);
	vhffsfssync_cookie.watch =3D NULL;
	vhffsfssync_cookie.id =3D 0;
	vhffsfssync_cookie.filename =3D NULL;

	inotifyfd =3D inotify_init();

	/* set inotifyfd to non-blocking */
	flags =3D fcntl(inotifyfd, F_GETFL);
	if(flags >=3D 0) {
		flags |=3D O_NONBLOCK;
		fcntl(inotifyfd, F_SETFL, flags);
	}

	watch =3D vhffsfssync_add_watch_recursively(inotifyfd, NULL, root, VHFFSFS=
SYNC_WATCH_MASK);
	if(!watch)  {
		fprintf(stdout, "%s: Maximum number of watches probably reached, consider=
 adding more or fixing what is being wrong before running me again (strace =
is your friend)... byebye!\n", vhffsfssync_debugts() );
		return -1;
	}

	printf("%s: Ready\n", vhffsfssync_debugts() );

	/* -- main loop -- */
	while(1)  {
		int max_fd =3D 0;
		fd_set readfs;
		int ret;

		FD_ZERO(&readfs);

		/* inotify events */
		FD_SET(inotifyfd, &readfs);
		if(inotifyfd > max_fd) max_fd =3D inotifyfd;

		ret =3D select(max_fd + 1, &readfs, NULL, NULL, NULL);
		if(ret < 0)  {
			switch(errno)  {
				case EAGAIN:
				case EINTR:
					break;
				default:
					fprintf(stdout, "%s: select() failed: %s\n", vhffsfssync_debugts(), st=
rerror(errno));
			}
		}
		if(ret > 0)  {
			/* inotify events */
			if( FD_ISSET(inotifyfd, &readfs) )  {
				char buf[VHFFSFSSYNC_BUF_LEN];
				ssize_t len;

				len =3D read(inotifyfd, buf, VHFFSFSSYNC_BUF_LEN);
				if(len < 0)  {
					switch(errno)  {
						case EAGAIN:
						case EINTR:
							break;
						default:
							fprintf(stdout, "%s: read() failed on inotify fd(%d): %s\n", vhffsfs=
sync_debugts(), inotifyfd, strerror(errno));
					}
				}
				else {
					char *cur =3D buf;
					int n=3D0;
					while(len > 0)  {
						int register next;
						struct inotify_event *ie;

						ie =3D (struct inotify_event*)cur;
						vhffsfssync_manage_event( inotifyfd, ie );
						next =3D sizeof(struct inotify_event);
						next +=3D ie->len;
						len -=3D next;
						cur +=3D next;
						n++;
					}
					//printf("COIN: %d events read\n", n);;
				}
			}

		}

		fflush(stdout);
//		sleep(10);
	}

	return 0;
}

--d6Gm4EdcadzBjdND--

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAky8y7wACgkQDFub3qtEsS/AjwCfWlpVIiFyxaXzOIS8JfRcB+/B
9AIAn1gfS6FTzgFD089n7xkPTfCTBo5B
=lHya
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
