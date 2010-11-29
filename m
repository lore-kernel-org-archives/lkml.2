Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab0K2Mwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 07:52:42 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40083 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0K2Mwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 07:52:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=h6nJ4y71Q0z+ahAVCEra+yLNPl7hwH03Bsi8PpP5dy/xX/d+TwExRWrgfT8n9BThYa
         w4J/zhmGhVyIdMbei/z+uqCvr16uk9M40bQzVzqEHOSqt85ECAihOing/Q8gfUNWmmVp
         a4Hnqx9fJp9njVM7R90hEpXnD7BhWradhSX64=
From: Jason Vas Dias <jason.vas.dias@gmail.com>
Reply-To: jason.vas.dias@gmail.com
To: 7eggert@gmx.de, linux-kernel@vger.kernel.org
Subject: Re: per-chroot clock module ?
Date: Mon, 29 Nov 2010 12:52:36 +0000
User-Agent: KMail/1.12.4 (Linux/2.6.34-jvd; KDE/4.3.4; x86_64; svn-1073138; 2010-01-11)
References: <fTxH4-2pP-5@gated-at.bofh.it> <fTyD7-3UB-11@gated-at.bofh.it> <E1PMfDt-00012L-Is@be1.7eggert.dyndns.org>
In-Reply-To: <E1PMfDt-00012L-Is@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011291252.36604.jason.vas.dias@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 November 2010 11:15:13 you wrote:
> Jason Vas Dias <jason.vas.dias@gmail.com> wrote:
> 
> > This would allow one to very easily support websites for totally different
> > timezones
> 
> Timezones can be set using environment variables.
> 
> man 8 tzselect
> 
> example:
> 
> $ date
> Sun Nov 28 12:11:39 CET 2010
> $ TZ="America/New_York" date
> Sun Nov 28 06:11:46 EST 2010
> 
> 
> 
> 
Yes, but that's not what I'm trying to do - as I said in previous mail: 
 "support websites for totally different timezones , where offsets need not be
  restricted to legal timezone offsets but could encompass years
 "
I'm not talking about legal locale timezones but of  "enabling groups of processes 
running in zones of completely different date / time values"  without adverse filesystem 
"modification time in the future"  side-effects - no false modification times would be
stored on disk nor any non-zero offset added to times seen by processses running
outside of a chroot. 

More precisely , the new "per_chroot_clock" module will provide :
 A built-in module function:
  o A very high performance "per_chroot_clock_for_root_inode()"  kernel / builtin function will return any associated
    real-time clock offset for the root inode of the current process or 0 if not found or the
    per_chroot_clock module is not installed. There would also be an 'per_chroot_any_clocks()'
    function to return >=1 if the module is installed and there are any successfully chroot-ed into root inodes with
    clocks defined, 0 otherwise.
 When the "per_chroot_clock" module is installed and there are any per_chroot clocks defined : 
  o After a successful chroot,  all processes running with a root inode of that chroot directory
    that issue the "clock_settime" system call will affect only the per-chroot clock offset for their root inode directory.
  o A "modify file stat" / "write inode" hook is added that will remove the offset from any inode modification times
    written by  a process with a root device inode in the set of inodes for which "clock_for_root_inode()"
    returns a non-zero value.
  o A "read inode" hook is added that will add any non-zero offset returned by "clock_for_root_inode()" when
    any stat() returns for a call from a process with such a root inode. Processes which issue stat() from outside
    the chroot will not see any offsets in file modification times when they look at files under the chroot .
  o time(), gettimofday(), clock_gettime () all get similar hooks so that if the module is installed,  the root inode
    number of the current process is used to lookup a clock offset to be added to the value returned , and processes
    that invoke these calls from within a chroot have that value added,  while those outside the chroot see no difference
    to the real-time clock time.
  o possibly clock_settime() and clock_gettime() could accept one single new "illegal clock" clock_t value that means 
    "ROOT_INODE_CLOCK" ; all processes could then inspect their per-root inode clock, regardless of whether 
    they have a chroot-ed root inode or not, and if there is none, the real-time clock is used.
  o a /proc filesystem interface ( eg /proc/$pid/per_chroot_clock ) will read / write the per_chroot root inode clock for
    the process - setting to 0 removes the offset.

I would find the above useful ,  and have already begun investigation & development on it -
I still don't know if anyone else would or if there is anything that does something like it out there .

All the best,
Jason
 

 
 
   


