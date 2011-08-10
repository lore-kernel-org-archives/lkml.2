Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1HJOWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:22:52 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57818 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab1HJOWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:22:50 -0400
Message-ID: <4E429407.8000209@linux.vnet.ibm.com>
Date: Wed, 10 Aug 2011 09:21:59 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Marcus Klemm <marcus.klemm@googlemail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, kvm@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, Brian King <brking@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] staging: zcache: support multiple clients, prep for
 KVM and RAMster
References: <1d15f28a-56df-4cf4-9dd9-1032f211c0d0@default>
In-Reply-To: <1d15f28a-56df-4cf4-9dd9-1032f211c0d0@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 02:01 PM, Dan Magenheimer wrote:
> Hi Greg --
> 
> I think this patch is now ready for staging-next and for merging when
> the 3.1 window opens.  Please let me know if you need any logistics
> done differently.
> 
> Thanks,
> Dan
> 
> ===
> 
>> From: Dan Magenheimer <dan.magenheimer@oracle.com>
> Subject: staging: zcache: support multiple clients, prep for KVM and RAMster
> 
> This is version 2 of an update to zcache, incorporating feedback from the list.
> This patch adds support to the in-kernel transcendent memory ("tmem") code
> and the zcache driver for multiple clients, which will be needed for both
> RAMster and KVM support.  It also adds additional tmem callbacks to support
> RAMster and corresponding no-op stubs in the zcache driver.  In v2, I've
> also taken the liberty of adding some additional sysfs variables to
> both surface information and allow policy control.  Those experimenting
> with zcache should find them useful.
> 
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> 
> [v2: konrad.wilk@oracle.com: fix bools, add check for NULL, fix a comment]
> [v2: sjenning@linux.vnet.ibm.com: add info/tunables for poor compression]
> [v2: marcusklemm@googlemail.com: add tunable for max persistent pages]
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: linux-mm@kvack.org
> Cc: kvm@vger.kernel.org
> 
> ===
> 
> Diffstat:
>  drivers/staging/zcache/tmem.c            |  100 +++-
>  drivers/staging/zcache/tmem.h            |   23 
>  drivers/staging/zcache/zcache.c          |  512 +++++++++++++++++----
>  3 files changed, 520 insertions(+), 115 deletions(-)
> 
> 
<cut>
> @@ -901,48 +1144,59 @@ static unsigned long zcache_curr_pers_pa
>  /* forward reference */
>  static int zcache_compress(struct page *from, void **out_va, size_t *out_len);
>  
> -static void *zcache_pampd_create(struct tmem_pool *pool, struct tmem_oid *oid,
> -				 uint32_t index, struct page *page)
> +static void *zcache_pampd_create(char *data, size_t size, bool raw, int eph,
> +				struct tmem_pool *pool, struct tmem_oid *oid,
> +				 uint32_t index)
>  {
>  	void *pampd = NULL, *cdata;
>  	size_t clen;
>  	int ret;
> -	bool ephemeral = is_ephemeral(pool);
>  	unsigned long count;
> +	struct page *page = virt_to_page(data);

With zcache_put_page() modified to pass page_address(page) instead of the 
actual page structure, in combination with the function signature changes 
to tmem_put() and zcache_pampd_create(), zcache_pampd_create() tries to 
(re)derive the page structure from the virtual address.  However, if the 
original page is a high memory page (or any unmapped page), this 
virt_to_page() fails because the page_address() in zcache_put_page()
returned NULL.

With CONFIG_DEBUG_VIRTUAL set, the BUG message is this:
==========
[  101.347711] ------------[ cut here ]------------
[  101.348030] kernel BUG at arch/x86/mm/physaddr.c:51!
[  101.348030] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[  101.348030] Modules linked in:
[  101.348030] 
[  101.348030] Pid: 20, comm: kswapd0 Not tainted 3.1.0-rc1+ #229 Bochs Bochs
[  101.348030] EIP: 0060:[<c1058c9a>] EFLAGS: 00010013 CPU: 0
[  101.348030] EIP is at __phys_addr+0x1a/0x50
[  101.348030] EAX: 00000000 EBX: f5e64000 ECX: 00000000 EDX: 00001000
[  101.348030] ESI: f6ffd000 EDI: 00000000 EBP: f6353c10 ESP: f6353c10
[  101.348030]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  101.348030] Process kswapd0 (pid: 20, ti=f6352000 task=f69b9c20 task.ti=f6352000)
[  101.348030] Stack:
[  101.348030]  f6353c60 c12e4114 00000000 00000001 00000000 c12e5682 00000000 00000046
[  101.348030]  00000000 f5e65668 f5e65658 f5e65654 f580f000 f6353c60 c13904f5 00000000
[  101.348030]  f5e65654 f5e64000 f5eab000 00000000 f6353cb0 c12e5713 00000000 f5e64000
[  101.348030] Call Trace:
[  101.348030]  [<c12e4114>] zcache_pampd_create+0x14/0x6a0
[  101.348030]  [<c12e5682>] ? tmem_put+0x52/0x3f0
[  101.348030]  [<c13904f5>] ? _raw_spin_lock+0x45/0x50
[  101.348030]  [<c12e5713>] tmem_put+0xe3/0x3f0
[  101.348030]  [<c10f5358>] ? page_address+0xb8/0xe0
[  101.348030]  [<c12e498b>] zcache_frontswap_put_page+0x1eb/0x2e0
[  101.348030]  [<c110798b>] __frontswap_put_page+0x6b/0x110
[  101.348030]  [<c1103ccf>] swap_writepage+0x8f/0xf0
[  101.348030]  [<c10ee377>] shmem_writepage+0x1a7/0x1d0
[  101.348030]  [<c10ea907>] shrink_page_list+0x3f7/0x7c0
[  101.348030]  [<c10eafdd>] shrink_inactive_list+0x12d/0x360
[  101.348030]  [<c10eb5f8>] shrink_zone+0x3e8/0x530
[  101.348030]  [<c10ebc92>] kswapd+0x552/0x940
[  101.348030]  [<c1084460>] ? wake_up_bit+0x30/0x30
[  101.348030]  [<c10eb740>] ? shrink_zone+0x530/0x530
[  101.348030]  [<c10840e4>] kthread+0x74/0x80
[  101.348030]  [<c1084070>] ? __init_kthread_worker+0x60/0x60
[  101.348030]  [<c1397736>] kernel_thread_helper+0x6/0xd
[  101.348030] Code: 00 c0 ff 81 eb 00 20 00 00 39 d8 72 cd eb ae 66 90 55 3d ff ff ff bf 89 e5 76 10 80 3d 10 88 53 c1 00 75 09 05 00 00 00 40 5d c3 <0f> 0b 8b 15 b0 6a 9e c1 81 c2 00 00 80 00 39 d0 72 e7 8b 15 a8 
[  101.348030] EIP: [<c1058c9a>] __phys_addr+0x1a/0x50 SS:ESP 0068:f6353c10
==========

This crash is hit every time a high memory page is swapped out.

I have no solution right now other that to revert this patch and 
restore the original signatures.

What was the rationale for the signature changes?

--
Seth
