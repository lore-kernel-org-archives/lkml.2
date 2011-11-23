Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1KWRgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:36:38 -0500
Received: from sperry-03.control.lth.se ([130.235.83.190]:49556 "EHLO
	sperry-03.control.lth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1KWRgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:36:37 -0500
Message-ID: <4ECD2F19.6070601@control.lth.se>
Date: Wed, 23 Nov 2011 18:36:25 +0100
From: Anders Blomdell <anders.blomdell@control.lth.se>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: It would be preferable to do a mount --bind --make-private in one
 atomic action [ASCII art this time]
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about previous posts used character set!

The rationale is the race problems I recently found with pam_namspace 
(see https://bugzilla.redhat.com/show_bug.cgi?id=755216). The following 
small script and it's output shows what pam_namespace essentially does 
does, and the problems that might occur; assume that /work is 
automounted, then the following really confuses things:

(
echo '# Empty work'
findmnt -a | cut -c1-30 | grep work
echo '# First primary mount on work'
ls -ld /work/Fedora-16/.
findmnt -a | cut -c1-30 | grep work
unshare --mount -- /bin/sh -c "(
     mount --bind /work /work ;
     mount --make-private /work ;
     mount --bind /tmp /work ;
     echo '# Detached mount of work' ;
     findmnt -a | cut -c1-30 | grep work ;
     sleep 5 ;
     echo '# Before detached unmount of private work' ;
     findmnt -a | cut -c1-30 | grep work;
     umount /work ;
     echo '# Before detached unmount of bound work' ;
     findmnt -a | cut -c1-30 | grep work;
     echo '# Weird detached automount behaviour' ;
     ls -ld /work/Fedora-15/. ;
     umount /work ;
     echo '# Detached unmount') &"
sleep 1
echo '# Second primary mount on work'
ls -ld /work/Fedora-15/.
findmnt -a | cut -c1-30 | grep work
echo '# First primary mount on work no longer accessible'
ls -ld /work/Fedora-16/.
sleep 10
echo '# And the final remaining cruft'
findmnt -a | cut -c1-30 | grep work
)

Which gives the following output (no wonder I had problems understanding 
what went wrong with my machines :-():

# Empty work
|-/work
# First primary mount on work
drwxr-xr-x 4 root root 4096 Nov 23 17:59 /work/Fedora-16/.
|-/work
| `-/work/Fedora-16
# Detached mount of work
|-/work
| |-/work/Fedora-16
| `-/work
|   `-/work
# Second primary mount on work
drwxr-xr-x 4 root root 4096 Nov 23 17:59 /work/Fedora-15/.
|-/work
| |-/work/Fedora-16
| |-/work
| | `-/work/Fedora-15
| `-/work/Fedora-15
# First primary mount on work no longer accessible
ls: cannot access /work/Fedora-16/.: Too many levels of symbolic links
# Before detached unmount of private work
|-/work
| |-/work/Fedora-16
| |-/work
| | `-/work
| `-/work/Fedora-15
# Before detached unmount of bound work
|-/work
| |-/work/Fedora-16
| |-/work
| `-/work/Fedora-15
# Weird detached automount behaviour
ls: cannot access /work/Fedora-15/.: Too many levels of symbolic links
# Detached unmount
# And the final remaining cruft
|-/work
| |-/work/Fedora-16
| |-/work
| | `-/work/Fedora-15
| `-/work/Fedora-15

-- 
Anders Blomdell                  Email: anders.blomdell@control.lth.se
Department of Automatic Control
Lund University                  Phone:    +46 46 222 4625
P.O. Box 118                     Fax:      +46 46 138118
SE-221 00 Lund, Sweden

