Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab0JWXap (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 19:30:45 -0400
Received: from smtp14.ono.com ([62.42.230.176]:49973 "EHLO resmaa14.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753406Ab0JWXan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 19:30:43 -0400
Date: Sun, 24 Oct 2010 01:30:38 +0200
From: "J.A. =?ISO-8859-1?B?TWFnYWxs824=?=" <jamagallon@ono.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: CIFS is slooow, gvfs is fast
Message-ID: <20101024013038.057442c0@werewolf.home>
In-Reply-To: <20101023004636.1acdd81c@werewolf.home>
References: <20101022013544.0fdab0e0@werewolf.home>
	<4CC16B1E.4060709@suse.de>
	<20101023004636.1acdd81c@werewolf.home>
X-Mailer: Claws Mail 3.7.6cvs54 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Oct 2010 00:46:36 +0200, "J.A. Magallón" <jamagallon@ono.com> wrote:

> On Fri, 22 Oct 2010 16:14:46 +0530, Suresh Jayaraman <sjayaraman@suse.de> wrote:
> 
> > (Cc linux-cifs@vger.kernel.org)
> > 
> > On 10/22/2010 05:05 AM, J.A. Magallón wrote:
> > 
> > > I have a very strange behaviour with windows networking.
> > > I have an HTPC, which I access from my Linux desktop. It runs Windows 7.
> > > Network is GigaBit, routed by a Linksys WRT320N running latest DD-WRT.
> > > I setup an automount path under /net/htpc with CIFS filesystem.
> > > I can also access the drives in HTPC via gvfs from Gnome DE.
> > > 
> > > Problem: speed is _VERY_ different.
> > > R/W through the automount point (CIFS fs), is roughly 7-8 MB/s (ridiculous
> > > for gigabit speeds).
> > > R/W through Gnome/gvfs (kind of fuse) goes around 35 - 40 MB/s (400 Mbits/s),
> > > that look much better.
> > 
> > What is the kernel version In which you are seeing the problem? I'm not
> 
> Its just new 2.6.36 final, mandriva distro kernel.
> 
> > seeing this on 2.6.36-rc4. Do you have a wired interface as well? Are
> 
> Yes, boxes are all wired to the 320N router, at gigabit speeds.
> Just to double check, I also probed with my netbook with 100Mb ehternet.
> The effect is less obvious, but writing to the Win7 box through the
> cifs automount path goes at 3.5-4.0 Mb/s, and with gvfs it reaches
> 7.5 Mb/s.
> 
> > you sure that both are using the same network path?
> > 
> 
> If you mean hardware network path (cabling, router), yes.
> For file paths, CIFS fs is under /net/htpc/media, and gvfs uses a mount
> point on '~/.gvfs/media on htpc'.
> 
> And here comes the weird part. To rule out the desktop environment factor,
> I tried a dd in both paths. On /net, I get 16.6 MB/s, and on
> ~/.gvfs/xxx, I just get 5.5 MB/s. I really don't understand anything...
> things get reversed depending if you use a gui or commandline.
> 
> Weird, really weird...
> 

Well, to sort things out, I did some more tests (this does not mean things
get any closer to be clear for me at least...).

Network card state in linux side:

werewolf:/etc/autofs# ethtool eth0
Settings for eth0:
    Supported ports: [ TP ]
    Supported link modes:   10baseT/Half 10baseT/Full
                            100baseT/Half 100baseT/Full
                            1000baseT/Full
    Supports auto-negotiation: Yes
    Advertised link modes:  10baseT/Half 10baseT/Full
                            100baseT/Half 100baseT/Full
                            1000baseT/Full
    Advertised auto-negotiation: Yes
    Speed: 1000Mb/s
    Duplex: Full
    Port: Twisted Pair
    PHYAD: 0
    Transceiver: internal
    Auto-negotiation: on
    Supports Wake-on: pg
    Wake-on: d
    Current message level: 0x00000000 (0)
    Link detected: yes
    
Raw iperf behaviour:

lnx -> win: [  3]  0.0-10.0 sec    988 MBytes    828 Mbits/sec
win -> lnx: [  4]  0.0-10.0 sec    333 MBytes    279 Mbits/sec

Don't know why the difference, but anyways worst speed is 280 Mb/s.

auto.master:
	/net/htpc   file:/etc/autofs/auto.htpc
auto.htpc:
	media -fstype=cifs,credentials=/etc/autofs/credentials/htpc,iocharset=utf8,uid=3001,gid=3000 ://htpc/media

Times for gnome-ui-copy are approximate, speed is what the copy window says.

Case A: automount via cifs.
/proc/mounts:
	/etc/autofs/auto.htpc /net/htpc autofs rw,relatime,fd=6,pgrp=14361,timeout=300,minproto=5,maxproto=5,indirect 0 0
	//htpc/media/ /net/htpc/media cifs rw,relatime,unc=\\htpc\media,username=media,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.1.20,file_mode=0755,dir_mode=0755,serverino,rsize=130048,wsize=57344 0 0

- dd if=~/file of=file.dd bs=1M
  292538368 bytes (293 MB) copied, 8.44771 s, 34.6 MB/s
- time cp ~/file file.cp: real    0m7.429s
- gnome UI copy: 39s, 7.8 MB/s

Case B: network mount via nautilus.
/proc/mounts:
	/etc/autofs/auto.htpc /net/htpc autofs rw,relatime,fd=6,pgrp=14361,timeout=300,minproto=5,maxproto=5,indirect 0 0
	gvfs-fuse-daemon /home/magallon/.gvfs fuse.gvfs-fuse-daemon rw,nosuid,nodev,relatime,user_id=3001,group_id=3000 0 0

- dd if=~/file of=file.dd bs=1M
  292538368 bytes (293 MB) copied, 50.4364 s, 5.8 MB/s
- time cp ~/file file.cp: real    0m50.151s
- gnome UI copy: 8s, 33.2 MB/s

And the best of all:

werewolf:~> time smbclient -U media%XXXXX //htpc/media -c 'put file'
Domain=[HOME] OS=[Windows 7 Enterprise 7600] Server=[Windows 7 Enterprise 6.1]
putting file file as \file (66345.1 kb/s) (average 66345.1 kb/s)

real    0m4.318s
user    0m0.466s
sys 0m0.553s

Can anybody tell me whats going here...??
It looks just like gui tools behave just in reverse of cli, and that a plain
smbclient is faster that cifs. I'm really confused...

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
