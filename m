Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab2DTRTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:19:46 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27739 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab2DTRTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:19:44 -0400
Message-ID: <4F919AA5.2030402@oracle.com>
Date: Fri, 20 Apr 2012 12:19:33 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120406 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Maxim V. Patlasov" <mpatlasov@parallels.com>
CC: Zach Brown <zab@zabbo.net>, Jeff Moyer <jmoyer@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 15/21] loop: use aio to perform io on the underlying
 file
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com> <1333122228-13633-16-git-send-email-dave.kleikamp@oracle.com> <4F917751.9040600@parallels.com> <4F917C2F.4020805@oracle.com> <x49mx66whty.fsf@segfault.boston.devel.redhat.com> <4F91862F.2030502@zabbo.net> <4F918758.8020001@oracle.com> <4F918B64.5030602@parallels.com>
In-Reply-To: <4F918B64.5030602@parallels.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F919AAD.003E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 11:14 AM, Maxim V. Patlasov wrote:
> On 04/20/2012 07:57 PM, Dave Kleikamp wrote:
>>> So yeah, I'd agree that the loop code should be reworked a bit so that
>>> both the filebacked and aio methods call vfs_sync() when they see
>>> REQ_FLUSH.
>> It's an easy fix. I don't anticipate that it will hurt performance too
>> badly.
> 
> Two questions:
> 
> 1. Could we use fdatasync there? (otherwise it can hurt performance very
> badly)

I don't see why not.

> 2. vfs_sync() is synchronous. loop_thread() will be blocked till it's
> completed. Would it be better to perform vfs_sync in another thread (to
> allow other bio-s in loop queue proceed)? Also, if there are more than
> one REQ_FLUSH bio in lo->lo_bio_list, we could call vfs_sync() only
> once. Make sense?

If more than one REQ_FLUSH bio is in the list, they should be performed
in order. We must call vfs_fsync() between each of them to guarantee that.

A less complex tradeoff would be to move the vfs_fsync() call to
loop_make_request() so it is called in the context of the thread making
the request. That would make those threads requesting ordered IO to pay
the price while others would be able to proceed.

This is something I can re-visit. I don't want to hold up progress on
the patchset for something that can be improved later.

> 
> Thanks,
> Maxim
