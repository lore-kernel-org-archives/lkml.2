Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259Ab2BJRIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:08:19 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:30875 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab2BJRIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:08:18 -0500
X-Authority-Analysis: v=2.0 cv=Vv2h8pKn c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=ODbK2BMGt0IA:10 a=TlgcxVd8wpcA:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=xe8BsctaAAAA:8 a=EDPlakg2NocGztOc9mAA:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4F354EFE.2080208@ubuntu.com>
Date: Fri, 10 Feb 2012 12:08:14 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: Jan Kara <jack@suse.cz>, Jerome Marchand <jmarchan@redhat.com>,
        linux-fsdevel@vger.kernel.org, util-linux@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] fs: filesystem specific options and remount
References: <4F2BFBAF.5020703@redhat.com> <20120206224116.GE24840@quack.suse.cz> <20120206230849.GA20767@x2.net.home>
In-Reply-To: <20120206230849.GA20767@x2.net.home>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/6/2012 6:08 PM, Karel Zak wrote:
> On Mon, Feb 06, 2012 at 11:41:16PM +0100, Jan Kara wrote:
>> On Fri 03-02-12 16:22:23, Jerome Marchand wrote:
>>> $ mount -o remount,hidepid=2 /proc/ $ grep proc /proc/mounts 
>>> /proc /proc proc rw,relatime,hidepid=2 0 0 $ mount | grep proc 
>>> proc on /proc type proc (rw,hidepid=2)
>>> 
>>> $ mount -o remount /proc/ $ grep proc /proc/mounts /proc /proc
>>> proc rw,relatime,hidepid=2 0 0 $ mount | grep proc proc on
>>> /proc type proc (rw)
> man mount:
> 
> The  remount  functionality follows the standard way how the mount 
> command works with options from fstab. It means the mount command 
> doesn't read fstab (or mtab) only when  a  device  and dir are
> fully specified.
> 
> mount -o remount,rw /dev/foo /dir
> 
> After this call all old mount options are replaced and arbitrary
> stuff from fstab is ignored, except the loop= option which is
> internally generated and maintained by the mount command.
> 
> mount -o remount,rw  /dir
> 
> After this call mount reads fstab (or mtab) and merges these
> options with options  from command line ( -o ).

Based on what you say there, I would guess this means that Jan has
proc listed in fstab, so mount tried to reset the mount options to
those specified in fstab, and the kernel proc fs left the options
unchanged.

It seems to me that the buggy behavior is in the proc fs not clearing
the unspecified options.  With the classic bitmask mount flags, any
that are not set are cleared by the remount, not left at their current
status.  This is why mount merges the existing flags specified in
fstab or mtab with those given on the command line.  The behavior
should be the same for the string passed mount flags.  In other words,
mount does its merging and whatever options are passed to the kernel
should be enabled, and any that are not should be disabled.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPNU7+AAoJEJrBOlT6nu75uyoH/3TxQOhOFGm2SlC0zwdh4Rld
/yotuzWpe27bjPHN9sychVEKeklhV+3kTHhK8DsiYwAHiJfwF2jyRFz9PTFYTmyj
7zLOi+7e7OFkLWxTADb4ihfqXZjEiI8TIK3RmsqAYLglRLPXw5VNgqGjoJx+7gfR
YKu9gzRUhjRKFvXoKGskdeGsB+em/PeAgy0qFYI2Et7rHekrX5PZvsjKsw8jqu/O
T9zDtbb0HBCub1PouB5leRc6HKuwdipmDrZFS1SV2ymbclMYh6WTkOJA4ngWGQm7
ZCwAqifcTHNvKr/CoAlFZ+m/9b85aAa9gb8vPUWNpZwEv5xpldhvWazGlR8gMkc=
=FTgE
-----END PGP SIGNATURE-----
