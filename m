Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab2GKPbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:31:13 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38392 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758107Ab2GKPbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:31:09 -0400
Message-ID: <4FFD9C08.2070502@linux.vnet.ibm.com>
Date: Wed, 11 Jul 2012 08:30:16 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, wency@cn.fujitsu.com
Subject: Re: [RFC PATCH v3 3/13] memory-hotplug : unify argument of firmware_map_add_early/hotplug
References: <4FFAB0A2.8070304@jp.fujitsu.com> <4FFAB17F.2090209@jp.fujitsu.com>
In-Reply-To: <4FFAB17F.2090209@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071115-7182-0000-0000-000001F56B70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 03:25 AM, Yasuaki Ishimatsu wrote:
> @@ -642,7 +642,7 @@ int __ref add_memory(int nid, u64 start,
>  	}
> 
>  	/* create new memmap entry */
> -	firmware_map_add_hotplug(start, start + size, "System RAM");
> +	firmware_map_add_hotplug(start, start + size - 1, "System RAM");

I know the firmware_map_*() calls use inclusive end addresses
internally, but do we really need to expose them?  Both of the callers
you mentioned do:

	firmware_map_add_hotplug(start, start + size - 1, "System RAM");

or

                firmware_map_add_early(entry->addr,
                        entry->addr + entry->size - 1,
                        e820_type_to_string(entry->type));

So it seems a _bit_ silly to keep all of the callers doing this size-1
thing.  I also noted that the new caller that you added does the same
thing.  Could we just change the external calling convention to be
exclusive?

BTW, this patch should probably be first in your series.  It's a real
bugfix.

