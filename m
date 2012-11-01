Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2KAMwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 08:52:46 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44340 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab2KAMwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 08:52:44 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Jan Kara <jack@suse.cz>, John McCutchan <john@johnmccutchan.com>,
        Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>,
        Eric Paris <eparis@redhat.com>
Subject: Better support for (desktop) file search / indexing applications
Date: Thu, 1 Nov 2012 13:52:42 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.0-tp520; KDE/4.8.4; x86_64; ; )
Cc: Nepomuk Mailing List <nepomuk@kde.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Filesystem Development Mailinglist 
	<linux-fsdevel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201211011352.42476.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Some time ago I stumpled over a blog entry that kernel user inotify watch
limit is often not enough for Nepomuk File Watcher to be notified of file
renames, new files and file deletes reliably[1].

There has been a discussion about that on various places[2,3,4] and likely
others.


I am writing to help the Nepomuk team to get in contact with Kernel
developers who could advise or help on how to solve the issues they
have with the current filesystem notification APIs in the kernel.

I thus added to CC any DNotify, INotify and FANotify maintainers as well
as Jan Kara who analyzed the advantages and disadvantages of each approach
and also developed some patches about recursive mtimes. I can dig out the
links to that as well, just ask if you want that. I also cc LKML,
linux-fsdevel and Nepomuk mailinglist. Feel free to drop CCs that you
deem inapprobiate or to add some for other Linux desktop or server
file indexing projects. Please tell me if I missed other kernel developers
who worked on file notification stuff.


The following two main issues led to the discussion about adding
notification about user inotify watch limit or even having it raised
automatically via some policy kit mechanism:

1) Watches are not working recursively. Thus one has to add a watch to
each sub directory.

2) There are inotify file move events. But one has to watch source and
destination directory to get notified of a file move between these. Thus
one has to watch each directory again. File moves outside the watched
home directory will go unnotified unless every other accessible directory
is watched as well.


What would be nice to have for file indexers would be:

1) Recursive notifications. I.e. one watch for /home/martin can notify 
about everything what happens in sub directories of that directory.

2) File move events that work from the source directory. I.e. if
watching a directory like /home/martin recursively it would be nice to
be notified about:

a) A file is moved from one sub directory inside /home/martin to another
one inside it.

b) A file is moved outside /home/martin

While these enhancement would likely fix the issues desktop file search
applications have with the kernel notification APIs, there might be other
approaches I did not yet thought off... so feel free to comment with your
thoughts on it.


Furthermore there is an issue with updating the file index on login or
service start. In order to catch all other file renames a indexer would
have to run over every directory whose modification time stamp has changed
again in order to see whether a (checksummed) file has moved.

An approach like recursive mtime as proposed by Jan Kara can help to
improve initial scan times a lot.

As to what I know this scan has been enabled in Nepomuk recently, with the
hope that files are moved mainly during the user session is active. I
think thats an assumption that may be accurate for many cases.

Still something like recursive mtime or BTRFS generation numbers with
btrfs subvolume find-new PATH LASTGENERATION would help that case a lot.
The issue with the BTRFS approach is that it only works as root. A
solution to this would be to integrate it in some daemon that works as
root and have applications communicate via socket or DBUS with it.


Some of this issues may apply to server side services like constellio or
Apache SolR (Lucene) as well. For example when there has been a service
downtime and after service restart the service wants to pick up last
changes. Or for near realtime indexing.


I hope to help to unstick the current state. I think its important for
kernel and userspace developers to talk to each other about good ways
to move forward.

So maybe some time in the future:

martin@merkaba:~> cat /etc/sysctl.d/nepomuk.conf 
# Für Nepomuk File Indexer
# martin@merkaba:~> find -type d | wc -l
# 34515
#
# merkaba:/proc/sys/fs/inotify> cat max_user_watches 
# 8192

fs.inotify.max_user_watches = 200000

Wont be necessary anymore.

I found that SLES 11 SP 2, maybe earlier versions as well, raise the
user watch limit to 65536 by default. So this seems to have been an
issue in a server-oriented enterprise distribution as well.



[1] Alvaro Soliverez: Nepomuk not indexing a large home:
http://soliverez.com.ar/home/2012/10/nepomuk-not-indexing-a-large-home/

[2] [Nepomuk] User limit reached. Please raise the inotify user watch limit:
http://lists.kde.org/?l=nepomuk&m=134954456529570&w=2

[3] Vishesh Handa, Nepomuk Without Files: 
http://vhanda.in/blog/2012/08/nepomuk-without-files/

[4] Martin Sandsmark, KFileMon,: 
http://martinsandsmark.wordpress.com/2012/08/07/kfilemon/

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
