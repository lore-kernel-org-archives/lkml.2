Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113Ab2JXMvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:51:31 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:12382 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933636Ab2JXMvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:51:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344211200"; 
   d="scan'208";a="15358174"
Message-ID: <5087E444.60008@citrix.com>
Date: Wed, 24 Oct 2012 14:51:16 +0200
From: =?GB2312?B?Um9nZXIgUGF1IE1vbm6opg==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: liuxiaolei1124 <liuxiaolei1124@163.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: about the patch: Persistent grant maps for xen blk drivers
References: <6fa672f0.1d1fd.13a92ca063b.Coremail.liuxiaolei1124@163.com>
In-Reply-To: <6fa672f0.1d1fd.13a92ca063b.Coremail.liuxiaolei1124@163.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/10/12 14:40, liuxiaolei1124 wrote:
> Dear Roger:
>  
>      i have put the patch "Persistent grant maps for xen blk drivers"
> (https://lkml.org/lkml/2012/10/18/191) into my Dom0 which is 2.6.32.36.
> And when i start a vm, sometimes the blkback go to the BUG_ON.

I'm working on top of the next release (3.7.0-rc1), so I cannot assure
that this patch will work correctly on top of 2.6.32.36. I would
recommend you to switch to
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git and apply
my patch on top of the linux-next branch to perform the testing.

> + for (i = 0, j = 0; i < nseg; i++) {
> + if (!persistent_gnts[i] || !persistent_gnts[i]->handle) {
> + /* This is a newly mapped grant */
> + BUG_ON(j >= segs_to_map);       // BUG_ON here
> + if (unlikely(map[j].status != 0)) {
> + pr_debug(DRV_PFX "invalid buffer -- could not remap it\n");
> + map[j].handle = BLKBACK_INVALID_HANDLE;
> + ret |= 1;
> + if (persistent_gnts[i]) {
> + rb_erase(&persistent_gnts[i]->node,
> + &blkif->persistent_gnts);
> + blkif->persistent_gnt_c--;
> + kfree(persistent_gnts[i]);
> + persistent_gnts[i] = NULL;
> + }
> + }
> + }
>  
> i don't understand when j  >=  segs_to_unmap ?

It should never happen, if j >= segs_to_unmap and we hit the bug it
means we are trying to process more segments than the ones we have mapped.

> And i make a test,  i don't put the patch which in xen-blkfront.c into
> kernel, no matter i forced set pers_grants = 1 or set pers_grants = 0
> ,it's OK when i start a vm.

Do you have the dmesg from the DomU? Does it even start? Could you also
post the serial output of the crash (and the lines before the crash)?

Thanks for the testing, Roger.

