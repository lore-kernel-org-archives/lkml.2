Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319Ab2JYJ06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:26:58 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1818 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759306Ab2JYJ0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:26:54 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <508905D2.9070907@broadcom.com>
Date: Thu, 25 Oct 2012 11:26:42 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Ben Skeggs" <bskeggs@redhat.com>
cc: "Stanislaw Gruszka" <sgruszka@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG 3.7-rc1] nouveau cli->mutex possible recursive locking
 detected
References: <20121016124348.GB2274@redhat.com>
 <5087CD85.4010201@broadcom.com> <5087E2D8.9010703@broadcom.com>
In-Reply-To: <5087E2D8.9010703@broadcom.com>
X-WSS-ID: 7C97DA1841411478182-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 02:45 PM, Arend van Spriel wrote:
> On 10/24/2012 01:14 PM, Arend van Spriel wrote:
>> On 10/16/2012 02:43 PM, Stanislaw Gruszka wrote:
>>> I have this lockdep warning on wireless-testing tree based
>>> on 3.7-rc1 (no other patches except wireless bits).
>>>
>>> =============================================
>>> Restarting tasks ... done.
>>> [ INFO: possible recursive locking detected ]
>>> 3.7.0-rc1-wl+ #2 Not tainted
>>> ---------------------------------------------
>>> Xorg/2269 is trying to acquire lock:
>>>   (&cli->mutex){+.+.+.}, at: [<ffffffffa012a27f>]
>>> nouveau_bo_move_m2mf+0x5f/0x170 [nouveau]
>>>
>>> but task is already holding lock:
>>>   (&cli->mutex){+.+.+.}, at: [<ffffffffa012f3c4>]
>>> nouveau_abi16_get+0x34/0x100 [nouveau]
>>>
>>
>> I have observed the same bug so I built and tested v3.7-rc2 tag with
>> lockdep enabled. It has the same problem and it results in a failure to
>> resume after suspend. See below.
>>
>> Gr. AvS
>
> digging into the trace:
>
>
> nouveau_gem_ioctl_pushbuf() calls nouveau_abi16_get() which grabs the
> mutex. Assume this should protect the chan variable passed to
> nouveau_gem_pushbuf_validate(), which does a bit more that validate as
> it ends up in nouveau_bo_move_m2mf() which uses the drm->chan. However,
> it deadlocks before that.
>
> Gr. AvS

Maybe this helps. The two locations where the lock is grabbed are from 
the same commit (see below).

Gr. AvS

commit ebb945a94bba2ce8dff7b0942ff2b3f2a52a0a69
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Fri Jul 20 08:17:34 2012 +1000

     drm/nouveau: port all engines to new engine module format

     This is a HUGE commit, but it's not nearly as bad as it looks - any 
problems
     can be isolated to a particular chipset and engine combination.  It was
     simply too difficult to port each one at a time, the compat layers are
     *already* ridiculous.

     Most of the changes here are simply to the glue, the process for 
each of the
     engine modules was to start with a standard skeleton and copy+paste 
the old
     code into the appropriate places, fixing up variable names etc as 
needed.

     v2: Marcin Slusarz <marcin.slusarz@gmail.com>
     - fix find/replace bug in license header

     v3: Ben Skeggs <bskeggs@redhat.com>
     - bump indirect pushbuf size to 8KiB, 4KiB barely enough for 
userspace and
       left no space for kernel's requirements during GEM pushbuf 
submission.
     - fix duplicate assignments noticed by clang

     v4: Marcin Slusarz <marcin.slusarz@gmail.com>
     - add sparse annotations to nv04_fifo_pause/nv04_fifo_start
     - use ioread32_native/iowrite32_native for fifo control registers

     v5: Ben Skeggs <bskeggs@redhat.com>
     - rebase on v3.6-rc4, modified to keep copy engine fix intact
     - nv10/fence: unmap fence bo before destroying
     - fixed fermi regression when using nvidia gr fuc
     - fixed typo in supported dma_mask checking

     Signed-off-by: Ben Skeggs <bskeggs@redhat.com>



