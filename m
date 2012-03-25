Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab2CYPgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 11:36:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41660 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab2CYPgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 11:36:18 -0400
Date: Sun, 25 Mar 2012 19:36:12 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] proc: fix mount -t proc -o AAA
Message-ID: <20120325153612.GC4391@albatros>
References: <201203220903.15360.a.miskiewicz@gmail.com>
 <20120323171058.GA3279@albatros>
 <20120323161504.dced28b9.akpm@linux-foundation.org>
 <201203250924.06908.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201203250924.06908.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2012 at 09:24 +0200, Arkadiusz Miśkiewicz wrote:
> but there is another problem - unmounting it and mounting without options 
> causes old option to persist:
> 
> # mount none /proc -t proc -o hidepid=2
> # umount /proc
> # mount none /proc -t proc
> # grep "/proc" /proc/mounts
> none /proc proc rw,relatime,hidepid=2 0 0
> 
> There should be no hidepid=2 now.

No, that's an expected behaviour.

Procfs is a special filesystem.  Mount options are not reset on each
mount(2) as you can mount procfs multiple times at different mount points
(/proc/, /aaa/proc/, etc.).  Each time you add mount options they are
applied to _each_ mount point because there is no per-mount point sb, but
there is a per pid_ns superblock: pid_ns itself.  All options are stored
at pid_ns.

When you mount it another time without any option nothing should change
at the old mount points.  When you umount the last mount point all mount
options are still stored.  When you mount it again old options are used
(unless you override them).

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
