Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab0FUUJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:09:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33201 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab0FUUJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WjxoaKDRfexx+a64r5mgYRIY8P9T/Ns66cWfUWYWjisGPVoAe78eawCGwo9HBBkYa1
         OMscJJpOF0fARDHWo7mmfhDOdpQ1GUrEU6XISZb7o+CFAVwMPwjEQG9osz1UYGNKyH/4
         89etLSe+HH5dXjwH3EKJijrmAOHE8a/S/+v3A=
Date: Mon, 21 Jun 2010 22:01:18 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
Message-ID: <20100621200118.GA4021@nb-core2.darkstar.lan>
References: <alpine.DEB.2.00.1006180940140.11575@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1006180940140.11575@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 09:49:44AM -0500, Christoph Lameter wrote:
> Can produce it with make-kpkg building a kernel.
[...]
> linux-2.6$ strace -p21561
> Process 21561 attached - interrupt to quit
> semop(32768, {{0, -1, SEM_UNDO}}, 1
> 
> linux-2.6$ strace -p21751
> Process 21751 attached - interrupt to quit
> semop(32768, {{0, -1, SEM_UNDO}}, 1
> 
> linux-2.6$ strace -p21792
> Process 21792 attached - interrupt to quit
> semop(32768, {{0, -1, SEM_UNDO}}, 1
> 
> linux-2.6$ strace -p21793
> Process 21793 attached - interrupt to quit
> semop(32768, {{0, -1, SEM_UNDO}}, 1

Ah! I was trying to understand what was going on with apache... I see
the same symptoms with apache and prefork module: each child serves one
request and then just hangs until it's recycled.
Strace shows the same semop syscall.

# ipcs

------ Shared Memory Segments --------
key        shmid      owner      perms      bytes      nattch     status      

------ Semaphore Arrays --------
key        semid      owner      perms      nsems     
0x00000000 65536      www-data   600        1         

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages    

# cat /proc/sysvipc/sem
       key      semid perms      nsems   uid   gid  cuid  cgid      otime      ctime
         0      65536   600          1    33    33     0     0 1277149940 1277149903

# /tmp/getall 65536 -v
getall <id> [-v]
found 1 semaphores.
   0:   0 (cnt   4 zcnt   0)


Luca
