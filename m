Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab2JXMpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:45:25 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3855 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758471Ab2JXMpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:45:24 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <5087E2D8.9010703@broadcom.com>
Date: Wed, 24 Oct 2012 14:45:12 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Stanislaw Gruszka" <sgruszka@redhat.com>
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        "Ben Skeggs" <bskeggs@redhat.com>
Subject: Re: [BUG 3.7-rc1] nouveau cli->mutex possible recursive locking
 detected
References: <20121016124348.GB2274@redhat.com>
 <5087CD85.4010201@broadcom.com>
In-Reply-To: <5087CD85.4010201@broadcom.com>
X-WSS-ID: 7C993DAD3SK3271549-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 01:14 PM, Arend van Spriel wrote:
> On 10/16/2012 02:43 PM, Stanislaw Gruszka wrote:
>> I have this lockdep warning on wireless-testing tree based
>> on 3.7-rc1 (no other patches except wireless bits).
>>
>> =============================================
>> Restarting tasks ... done.
>> [ INFO: possible recursive locking detected ]
>> 3.7.0-rc1-wl+ #2 Not tainted
>> ---------------------------------------------
>> Xorg/2269 is trying to acquire lock:
>>   (&cli->mutex){+.+.+.}, at: [<ffffffffa012a27f>]
>> nouveau_bo_move_m2mf+0x5f/0x170 [nouveau]
>>
>> but task is already holding lock:
>>   (&cli->mutex){+.+.+.}, at: [<ffffffffa012f3c4>]
>> nouveau_abi16_get+0x34/0x100 [nouveau]
>>
>
> I have observed the same bug so I built and tested v3.7-rc2 tag with
> lockdep enabled. It has the same problem and it results in a failure to
> resume after suspend. See below.
>
> Gr. AvS

digging into the trace:


nouveau_gem_ioctl_pushbuf() calls nouveau_abi16_get() which grabs the 
mutex. Assume this should protect the chan variable passed to 
nouveau_gem_pushbuf_validate(), which does a bit more that validate as 
it ends up in nouveau_bo_move_m2mf() which uses the drm->chan. However, 
it deadlocks before that.

Gr. AvS

