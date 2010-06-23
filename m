Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0FWRvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:51:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:4538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab0FWRvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:51:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,468,1272870000"; 
   d="scan'208";a="810812841"
From: "Othman, Ossama" <ossama.othman@intel.com>
To: =?utf-8?B?SGVucmkgSMOka2tpbmVu?= <henuxd@gmail.com>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "alan@linux.intel.com" <alan@linux.intel.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Jun 2010 10:51:37 -0700
Subject: RE: [PATCH] Staging: memrar: Moved memrar_allocator struct into
 memrar_allocator.c
Thread-Topic: [PATCH] Staging: memrar: Moved memrar_allocator struct into
 memrar_allocator.c
Thread-Index: AcsSqCQixMBE2JbCQGaq2BX5NJ+lDgAUtU5Q
Message-ID: <A5FE05C4C76E4C4CAB15D9962B96FC950CEA180A03@orsmsx510.amr.corp.intel.com>
References: <1276519227-4987-1-git-send-email-henuxd@gmail.com>
In-Reply-To: <1276519227-4987-1-git-send-email-henuxd@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o5NHpqim018439

Hi,

> Forward declared memrar_allocator in memrar_allocator.h and moved it
> to memrar_allocator.c file.  Implemented memrar_allocator_capacity(),
> memrar_allocator_largest_free_area(), memrar_allocoator_lock() and
> memrar_allocator_unlock().
...
> -	mutex_lock(&allocator->lock);
> -	r->largest_block_size = allocator->largest_free_area;
> -	mutex_unlock(&allocator->lock);
> +	memrar_allocator_lock(allocator);
> +	r->largest_block_size =
> memrar_allocator_largest_free_area(allocator);
> +	memrar_allocator_unlock(allocator);

I don't think it's necessary to expose the allocator lock.  Why not just grab the lock in memrar_allocator_largest_free_area() while the underlying struct field is being accessed and then unlock it before that function returns?  That would allow the allocator lock to remain an internal implementation detail.  We only need to ensure access to the struct field itself is synchronized, e.g.:

size_t memrar_allocator_largest_free_area(struct memrar_allocator *allocator)
{
	size_t tmp = 0;

	if (allocator != NULL) {
		mutex_lock(&allocator->lock);
		tmp = allocator->largest_free_area;
		mutex_unlock(&allocator->lock);
	}

	return tmp;
}

Certainly the allocator->largest_free_area value could be updated after the lock is released and by the time it is returned to the user (for statistical purposes), but at least the internal allocator state would remain consistent in the presences of multiple threads.

HTH,
-Ossama

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
