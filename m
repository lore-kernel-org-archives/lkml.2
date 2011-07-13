Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab1GMU1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:27:53 -0400
Received: from SIPB-VM-99.MIT.EDU ([18.181.0.178]:58350 "EHLO
	ocaml.xvm.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1GMU1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:27:51 -0400
X-Greylist: delayed 1137 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jul 2011 16:27:51 EDT
Message-ID: <4E1DFB4E.7050107@xsdg.org>
Date: Wed, 13 Jul 2011 20:08:46 +0000
From: Omari Stephens <xsdg@xsdg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101127 Lanikai/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: In-kernel deadlock of some sort with 2.6.39.2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me on responses, since I'm not on lkml.

### Short version:
Under 2.6.39.2, one of my machines regularly gets into a state where 
processes end up in uninterruptible waits that never end.  One peculiar 
thing that happens is that attempts to stat(1) or read certain files 
from procfs never return.

I am pretty familiar with compiling and running my own kernels, but not 
so familiar with troubleshooting when non-obvious things go wrong.  Any 
suggestions would be appreciated, even if it's "we might've fixed 
something related in version XYZ, try that one"

I've uploaded my config here:
http://web.mit.edu/~xsdg/Public/stuff/kernel/broken_2.6.39.2_config.txt


### Detailed version:
On one of my machines, I recently compiled and installed 2.6.39.2 
alongside a switch from the nv driver to nouveau.  This was specifically 
to solve an issue where FF7 nightly would cause high CPU usage in X just 
by virtue of painting the screen.

The upgrade did fix my X issues, FF7 is as smooth as could be hoped on 
this machine, but now FF periodically (but repeatably, after a reboot) 
stops responding.  According to top, the system is about 94% IO-wait.:
Cpu0  :  3.7%us,  2.4%sy,  0.0%ni,  0.0%id, 93.9%wa,  0.0%hi,  0.0%si, 
0.0%st

Oddly, I noticed that running `ps` would halt uninterruptibly.  After 
some further debugging, I discovered that attempting to stat (not even 
read) certain files in procfs will never return.  For instance:

19:36:38> [xsdg{perl}@/proc/4950]
$find | sort | xargs stat
[...]
   File: `./environ'
   Size: 0         	Blocks: 0          IO Block: 1024   regular empty file
Device: 3h/3d	Inode: 6413606     Links: 1
Access: (0400/-r--------)  Uid: ( 1000/    xsdg)   Gid: ( 1000/    xsdg)
Access: 2011-07-13 19:26:15.829482661 +0000
Modify: 2011-07-13 19:26:15.829482661 +0000
Change: 2011-07-13 19:26:15.829482661 +0000
[sits here indefinitely]

By the magical powers of deduction:
19:36:50> [xsdg{perl}@/proc/4950]
$l exe
[sits here indefinitely]

Oddly, I can stat cmdline with no issues, but if I try to _read_ it, 
then it blocks.  As you might imagine, I have no idea what process 4950 is.
19:56:16> [xsdg{perl}@/proc/4950]
$stat cmdline
   File: `cmdline'
   Size: 0         	Blocks: 0          IO Block: 1024   regular empty file
Device: 3h/3d	Inode: 3553148     Links: 1
Access: (0444/-r--r--r--)  Uid: ( 1000/    xsdg)   Gid: ( 1000/    xsdg)
Access: 2011-07-12 18:13:35.481767937 +0000
Modify: 2011-07-12 18:13:35.481767937 +0000
Change: 2011-07-12 18:13:35.481767937 +0000

19:56:18> [xsdg{perl}@/proc/4950]
$cat cmdline
[sits here indefinitely]

--xsdg
   http://blog.doppler-photo.net/
