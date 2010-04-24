Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0DXXLO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 19:11:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:43393 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754064Ab0DXXLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 19:11:12 -0400
X-Authenticated: #181789
X-Provags-ID: V01U2FsdGVkX1/guGwDRRbgaOhSAG1ltS6aiBmJXa9BUJ1MjbNQF6
	Beeen+c2xcyw0L
From: Christian Eggers <ceggers@gmx.de>
To: Jeff Layton <jlayton@redhat.com>
Subject: Re: cifs: [solved] Filesystem unmounts automatically after some time
Date: Sun, 25 Apr 2010 01:11:06 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.25.20-0.7-xen; KDE/4.4.2; x86_64; ; )
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
References: <201004232148.52739.ceggers@gmx.de> <20100423220908.480ce1f4@corrin.poochiereds.net>
In-Reply-To: <20100423220908.480ce1f4@corrin.poochiereds.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004250111.06868.ceggers@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jeff,

Am Samstag 24 April 2010 04:09:08 schrieb Jeff Layton:
> Christian Eggers <ceggers@gmx.de> wrote:
> > [...]
> > When I mount a remote Samba share with the previous commands, the share
> > gets successfully mounted and is shown in the output of the "mount"
> > command. After some minutes the share is automatically unmounted without
> > any user intervention. Is this a wanted feature or a bug?
> > 
> > I saw this behaviour first on openSUSE 11.2 (shipped with
> > kernel-2.6.31.5) but never on openSUSE 11.1 (kernel-2.6.27.7).
> 
> Sounds like a bug, but I'm not sure if it's in CIFS or even in the
> kernel.
> 
> > [...]
> 
> ...and then the last reference to the superblock was put. I can't be
> certain, but it seems plausible that something in userspace is
> triggering a umount. What may be interesting is to boot the box into
> single-user mode and redo the mount. Does it still end up unmounted
> after a little while?

I've tested in single-user mode (I had to setup the network manually for this). Here the problem doesn't happen.

> It also could be a matter of more vfsmount references being put than
> "got", possibly with the last reference being put in the statfs
> codepath above. This would be the first I've heard of such a problem
> however and would probably not be a cifs-specific issue.


[repeated]
> but it seems plausible that something in userspace is
> triggering a umount.
This was the problem! After this hint I looked into syslog (until this point I had only searched in dmesg output)...

> Apr 24 23:15:49 p2400 dhcpcd[2958]: br0: renewing lease of 192.168.0.40
> Apr 24 23:15:49 p2400 dhcpcd[2958]: br0: leased 192.168.0.40 for 600 seconds 
> Apr 24 23:15:49 p2400 dhcpcd[2958]: br0: adding IP address 192.168.0.40/24 
> Apr 24 23:15:49 p2400 dhcpcd[2958]: br0: adding default route via 192.168.0.1 metric 0 
> Apr 24 23:15:49 p2400 ifup:     br0
> Apr 24 23:15:49 p2400 kernel: [  922.705969] /home/christian/intel/linux-2.6.34-rc/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 8 with uid: 0 
> [...]
> Apr 24 23:15:49 p2400 kernel: [  922.708433] /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifsfs.c: In cifs_put_super
> Apr 24 23:15:49 p2400 kernel: [  922.708437] /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: CIFS VFS: incifs_put_tcon as Xid: 10 with uid: 0 
> Apr 24 23:15:49 p2400 kernel: [  922.708440]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifssmb.c: In tree disconnect 
> [...]

After some investigation, I found out that my share is umounted by ...
  dhcpcp
  --> /etc/sysconfig/network/scripts/dhcpcd-hook
    --> if-up br0 -o dhcp
      --> if-up.d/21-smbfs
        --> /usr/sbin/rcsmbfs restart
          --> umount -ta cifs

It seems that openSUSE didn't thought about the possibility, that somebody might mount cifs shares with other methods than their rcsmbfs script. But also in this case all shares would be umounted (and newly mounted after that) every time the dhcp lease is renewed. I 
think the rest of the problem (should if-up be called after a lease renewal, is it correct to call rcsmbfs from if-up, ...) is very specific to openSUSE. I'll submit a bug on their bug tracker the next days.

Thank you very much for your help.

Christian
