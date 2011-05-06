Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1EFIwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 04:52:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52200 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab1EFIw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 04:52:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=the2masters.de; s=mail;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=ut5TvMoI8QBnF/Qtmi7N+JrrIrUeimnU+EpeLcZigcT3rLuRpK5GQszHj0Uv4pvN9E
         4s7Gvy6w+4bIdK03sAAp7ZZB4rTiIUPLY1xBqD7ftnlSQBKjVzy3jyZ/R2xEaEcXD3K/
         8/cpyJj8Rx1qKoqSWoYlfstNYMY3dpswm71eU=
Message-ID: <4DC3B6C6.7000704@the2masters.de>
Date: Fri, 06 May 2011 10:52:22 +0200
From: Stefan Hellermann <stefan@the2masters.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: early crash on ancient tablet related to no-bootmem
References: <4DC30251.9040902@the2masters.de> <4DC31D5F.8070209@the2masters.de> <4DC31F72.5050206@kernel.org> <4DC328AC.1060906@the2masters.de> <4DC3958F.1090800@kernel.org>
In-Reply-To: <4DC3958F.1090800@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------010202020300070101070404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010202020300070101070404
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Am 06.05.2011 08:30, schrieb Yinghai Lu:
> 
> please check
> 
> [PATCH] mm: Use alloc_bootmem_node_nopanic on really needed path
> 
> Stefan found nobootmem does not work on his system that only have 8M ram.
> 
> It turns out we should ignore the low limit the 16M.
> 
> Use alloc_bootmem_node_nopanic in those calling.
> 
> Reported-by: Stefan Hellermann <stefan@the2masters.de>
> Signed-off-by: Yinghai LU <yinghai@kernel.org>

You found it! bootlog attached.
Tested-by: Stefan Hellermann <stefan@the2masters.de>

> 
> ---
>  include/linux/bootmem.h |    2 ++
>  mm/page_alloc.c         |    6 +++---
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/include/linux/bootmem.h
> ===================================================================
> --- linux-2.6.orig/include/linux/bootmem.h
> +++ linux-2.6/include/linux/bootmem.h
> @@ -111,6 +111,8 @@ extern void *__alloc_bootmem_low_node(pg
>  	__alloc_bootmem_nopanic(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
>  #define alloc_bootmem_node(pgdat, x) \
>  	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
> +#define alloc_bootmem_node_nopanic(pgdat, x) \
> +	__alloc_bootmem_node_nopanic(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
>  #define alloc_bootmem_pages_node(pgdat, x) \
>  	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
>  #define alloc_bootmem_pages_node_nopanic(pgdat, x) \
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -3564,7 +3564,7 @@ int zone_wait_table_init(struct zone *zo
>  
>  	if (!slab_is_available()) {
>  		zone->wait_table = (wait_queue_head_t *)
> -			alloc_bootmem_node(pgdat, alloc_size);
> +			alloc_bootmem_node_nopanic(pgdat, alloc_size);
>  	} else {
>  		/*
>  		 * This case means that a zone whose size was 0 gets new memory
> @@ -4141,7 +4141,7 @@ static void __init setup_usemap(struct p
>  	unsigned long usemapsize = usemap_size(zonesize);
>  	zone->pageblock_flags = NULL;
>  	if (usemapsize)
> -		zone->pageblock_flags = alloc_bootmem_node(pgdat, usemapsize);
> +		zone->pageblock_flags = alloc_bootmem_node_nopanic(pgdat, usemapsize);
>  }
>  #else
>  static inline void setup_usemap(struct pglist_data *pgdat,
> @@ -4307,7 +4307,7 @@ static void __init_refok alloc_node_mem_
>  		size =  (end - start) * sizeof(struct page);
>  		map = alloc_remap(pgdat->node_id, size);
>  		if (!map)
> -			map = alloc_bootmem_node(pgdat, size);
> +			map = alloc_bootmem_node_nopanic(pgdat, size);
>  		pgdat->node_mem_map = map + (pgdat->node_start_pfn - start);
>  	}
>  #ifndef CONFIG_NEED_MULTIPLE_NODES


--------------010202020300070101070404
Content-Type: text/plain;
 name="bootlog.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="bootlog.txt"

ZWFybHkgY29uc29sZSBpbiBzZXR1cCBjb2RlCmVhcmx5IGNvbnNvbGUgaW4gZGVjb21wcmVz
c19rZXJuZWwKCkRlY29tcHJlc3NpbmcgTGludXguLi4gUGFyc2luZyBFTEYuLi4gZG9uZS4K
Qm9vdGluZyB0aGUga2VybmVsLgpMaW51eCB2ZXJzaW9uIDIuNi4zOS1yYzYrIChzdGVmYW5A
aGVsLXN0ZWZhbi5sYW4pIChnY2MgdmVyc2lvbiA0LjYuMCAyMDExMDQyOCAoUmVkIEhhdCA0
LjYuMC02KSAoR0NDKSApICM5IEZyaSBNYXkgNiAwOTozOTozMSBDRVNUIDIwMTEKQklPUy1w
cm92aWRlZCBwaHlzaWNhbCBSQU0gbWFwOgogQklPUy04ODogMDAwMDAwMDAwMDAwMDAwMCAt
IDAwMDAwMDAwMDAwOWYwMDAgKHVzYWJsZSkKIEJJT1MtODg6IDAwMDAwMDAwMDAxMDAwMDAg
LSAwMDAwMDAwMDAwODQwMDAwICh1c2FibGUpCmJvb3Rjb25zb2xlIFtlYXJseXNlcjBdIGVu
YWJsZWQKZGVidWc6IGlnbm9yaW5nIGxvZ2xldmVsIHNldHRpbmcuCk5vdGljZTogTlggKEV4
ZWN1dGUgRGlzYWJsZSkgcHJvdGVjdGlvbiBtaXNzaW5nIGluIENQVSEKRE1JIG5vdCBwcmVz
ZW50IG9yIGludmFsaWQuCmU4MjAgdXBkYXRlIHJhbmdlOiAwMDAwMDAwMDAwMDAwMDAwIC0g
MDAwMDAwMDAwMDAxMDAwMCAodXNhYmxlKSA9PT4gKHJlc2VydmVkKQplODIwIHJlbW92ZSBy
YW5nZTogMDAwMDAwMDAwMDBhMDAwMCAtIDAwMDAwMDAwMDAxMDAwMDAgKHVzYWJsZSkKbGFz
dF9wZm4gPSAweDg0MCBtYXhfYXJjaF9wZm4gPSAweDEwMDAwMAogICAgbWVtYmxvY2tfeDg2
X3Jlc2VydmVfcmFuZ2U6IFsweDAwNmE5MDAwLTB4MDA2YWJmZmZdICAgICAgICAgICAgICBC
UksKTUVNQkxPQ0sgY29uZmlndXJhdGlvbjoKIG1lbW9yeSBzaXplID0gMHg3Y2YwMDAKIG1l
bW9yeS5jbnQgID0gMHgyCiBtZW1vcnlbMHgwXQlbMHgwMDAwMDAwMDAxMDAwMC0weDAwMDAw
MDAwMDllZmZmXSwgMHg4ZjAwMCBieXRlcwogbWVtb3J5WzB4MV0JWzB4MDAwMDAwMDAxMDAw
MDAtMHgwMDAwMDAwMDgzZmZmZl0sIDB4NzQwMDAwIGJ5dGVzCiByZXNlcnZlZC5jbnQgID0g
MHgyCiByZXNlcnZlZFsweDBdCVsweDAwMDAwMDAwMDlmMDAwLTB4MDAwMDAwMDAwZmZmZmZd
LCAweDYxMDAwIGJ5dGVzCiByZXNlcnZlZFsweDFdCVsweDAwMDAwMDAwNDAwMDAwLTB4MDAw
MDAwMDA2YWJmZmZdLCAweDJhYzAwMCBieXRlcwppbml0aWFsIG1lbW9yeSBtYXBwZWQgOiAw
IC0gMDBjMDAwMDAKICAgIG1lbWJsb2NrX3g4Nl9yZXNlcnZlX3JhbmdlOiBbMHgwMDA5ZTAw
MC0weDAwMDllZmZmXSAgICAgICBUUkFNUE9MSU5FCkJhc2UgbWVtb3J5IHRyYW1wb2xpbmUg
YXQgW2MwMDllMDAwXSA5ZTAwMCBzaXplIDQwOTYKaW5pdF9tZW1vcnlfbWFwcGluZzogMDAw
MDAwMDAwMDAwMDAwMC0wMDAwMDAwMDAwODQwMDAwCiAwMDAwMDAwMDAwIC0gMDAwMDg0MDAw
MCBwYWdlIDRrCmtlcm5lbCBkaXJlY3QgbWFwcGluZyB0YWJsZXMgdXAgdG8gODQwMDAwIEAg
ODNhMDAwLTg0MDAwMAo4TUIgTE9XTUVNIGF2YWlsYWJsZS4KICBtYXBwZWQgbG93IHJhbTog
MCAtIDAwODQwMDAwCiAgbG93IHJhbTogMCAtIDAwODQwMDAwClpvbmUgUEZOIHJhbmdlczoK
ICBETUEgICAgICAweDAwMDAwMDEwIC0+IDB4MDAwMDEwMDAKICBOb3JtYWwgICBlbXB0eQpN
b3ZhYmxlIHpvbmUgc3RhcnQgUEZOIGZvciBlYWNoIG5vZGUKZWFybHlfbm9kZV9tYXBbMl0g
YWN0aXZlIFBGTiByYW5nZXMKICAgIDA6IDB4MDAwMDAwMTAgLT4gMHgwMDAwMDA5ZgogICAg
MDogMHgwMDAwMDEwMCAtPiAweDAwMDAwODQwCk9uIG5vZGUgMCB0b3RhbHBhZ2VzOiAxOTk5
CiAgICBtZW1ibG9ja194ODZfcmVzZXJ2ZV9yYW5nZTogWzB4MDA4MjgwMDAtMHgwMDgzZmZm
Zl0gICAgICAgICAgQk9PVE1FTQpmcmVlX2FyZWFfaW5pdF9ub2RlOiBub2RlIDAsIHBnZGF0
IGMwNjU5NDIwLCBub2RlX21lbV9tYXAgYzA4MjgyMDAKICBETUEgem9uZTogMTcgcGFnZXMg
dXNlZCBmb3IgbWVtbWFwCiAgRE1BIHpvbmU6IDAgcGFnZXMgcmVzZXJ2ZWQKICBETUEgem9u
ZTogMTk4MiBwYWdlcywgTElGTyBiYXRjaDowCiAgICBtZW1ibG9ja194ODZfcmVzZXJ2ZV9y
YW5nZTogWzB4MDA4MjdmZjAtMHgwMDgyN2ZmM10gICAgICAgICAgQk9PVE1FTQogICAgbWVt
YmxvY2tfeDg2X3Jlc2VydmVfcmFuZ2U6IFsweDAwODI3ZmIwLTB4MDA4MjdmZWZdICAgICAg
ICAgIEJPT1RNRU0KICAgIG1lbWJsb2NrX3g4Nl9yZXNlcnZlX3JhbmdlOiBbMHgwMDgyN2Y1
MC0weDAwODI3ZmEzXSAgICAgICAgICBCT09UTUVNCiAgICBtZW1ibG9ja194ODZfcmVzZXJ2
ZV9yYW5nZTogWzB4MDA4MjdmMTAtMHgwMDgyN2Y0Zl0gICAgICAgICAgQk9PVE1FTQogICAg
bWVtYmxvY2tfeDg2X3Jlc2VydmVfcmFuZ2U6IFsweDAwODI3ZWQwLTB4MDA4MjdmMGZdICAg
ICAgICAgIEJPT1RNRU0KQWxsb2NhdGluZyBQQ0kgcmVzb3VyY2VzIHN0YXJ0aW5nIGF0IDg0
MDAwMCAoZ2FwOiA4NDAwMDA6ZmY3YzAwMDApCiAgICBtZW1ibG9ja194ODZfcmVzZXJ2ZV9y
YW5nZTogWzB4MDA4MjdlNTAtMHgwMDgyN2VjNV0gICAgICAgICAgQk9PVE1FTQogICAgbWVt
YmxvY2tfeDg2X3Jlc2VydmVfcmFuZ2U6IFsweDAwODI3ZGQwLTB4MDA4MjdlNDVdICAgICAg
ICAgIEJPT1RNRU0KICAgIG1lbWJsb2NrX3g4Nl9yZXNlcnZlX3JhbmdlOiBbMHgwMDgyNmRk
MC0weDAwODI3ZGNmXSAgICAgICAgICBCT09UTUVNCiAgICBtZW1ibG9ja194ODZfcmVzZXJ2
ZV9yYW5nZTogWzB4MDA4MWUwMDAtMHgwMDgyNWZmZl0gICAgICAgICAgQk9PVE1FTQogICAg
bWVtYmxvY2tfeDg2X3Jlc2VydmVfcmFuZ2U6IFsweDAwODI2ZGMwLTB4MDA4MjZkYzNdICAg
ICAgICAgIEJPT1RNRU0KICAgIG1lbWJsb2NrX3g4Nl9yZXNlcnZlX3JhbmdlOiBbMHgwMDgy
NmRiMC0weDAwODI2ZGIzXSAgICAgICAgICBCT09UTUVNCiAgICBtZW1ibG9ja194ODZfcmVz
ZXJ2ZV9yYW5nZTogWzB4MDA4MjZkYTAtMHgwMDgyNmRhM10gICAgICAgICAgQk9PVE1FTQog
ICAgbWVtYmxvY2tfeDg2X3Jlc2VydmVfcmFuZ2U6IFsweDAwODI2ZDkwLTB4MDA4MjZkOTNd
ICAgICAgICAgIEJPT1RNRU0KcGNwdS1hbGxvYzogczAgcjAgZDMyNzY4IHUzMjc2OCBhbGxv
Yz0xKjMyNzY4CnBjcHUtYWxsb2M6IFswXSAwIAogICAgbWVtYmxvY2tfeDg2X3Jlc2VydmVf
cmFuZ2U6IFsweDAwODI2ZDEwLTB4MDA4MjZkODddICAgICAgICAgIEJPT1RNRU0KICAgIG1l
bWJsb2NrX3g4Nl9yZXNlcnZlX3JhbmdlOiBbMHgwMDgyNmNlMC0weDAwODI2ZDBiXSAgICAg
ICAgICBCT09UTUVNCkJ1aWx0IDEgem9uZWxpc3RzIGluIFpvbmUgb3JkZXIsIG1vYmlsaXR5
IGdyb3VwaW5nIG9mZi4gIFRvdGFsIHBhZ2VzOiAxOTgyCktlcm5lbCBjb21tYW5kIGxpbmU6
IHJvb3Q9L2Rldi9oZGEyIHBhcnBvcnQ9MHgzNzgsNyBpbml0PS9ldGMvcHJlaW5pdCBub2lu
aXRyZCBlYXJseXByaW50az10dHlTMCw5NjAwIGlnbm9yZV9sb2dsZXZlbCBkZWJ1ZyBtZW1i
bG9jaz1kZWJ1ZwogICAgbWVtYmxvY2tfeDg2X3Jlc2VydmVfcmFuZ2U6IFsweDAwODI2YzYw
LTB4MDA4MjZjZGZdICAgICAgICAgIEJPT1RNRU0KUElEIGhhc2ggdGFibGUgZW50cmllczog
MzIgKG9yZGVyOiAtNSwgMTI4IGJ5dGVzKQogICAgbWVtYmxvY2tfeDg2X3Jlc2VydmVfcmFu
Z2U6IFsweDAwODFkMDAwLTB4MDA4MWRmZmZdICAgICAgICAgIEJPT1RNRU0KRGVudHJ5IGNh
Y2hlIGhhc2ggdGFibGUgZW50cmllczogMTAyNCAob3JkZXI6IDAsIDQwOTYgYnl0ZXMpCiAg
ICBtZW1ibG9ja194ODZfcmVzZXJ2ZV9yYW5nZTogWzB4MDA4MWMwMDAtMHgwMDgxY2ZmZl0g
ICAgICAgICAgQk9PVE1FTQpJbm9kZS1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDEwMjQg
KG9yZGVyOiAwLCA0MDk2IGJ5dGVzKQpJbml0aWFsaXppbmcgQ1BVIzAKU3VidHJhY3QgKDE0
IGVhcmx5IHJlc2VydmF0aW9ucykKICBbMDAwMDA5ZTAwMC0wMDAwMGZmZmZmXQogIFswMDAw
NDAwMDAwLTAwMDA2YWJmZmZdCiAgWzAwMDA4MWMwMDAtMDAwMDgyNWZmZl0KICBbMDAwMDgy
NmM2MC0wMDAwODI2ZDBiXQogIFswMDAwODI2ZDEwLTAwMDA4MjZkODddCiAgWzAwMDA4MjZk
OTAtMDAwMDgyNmQ5M10KICBbMDAwMDgyNmRhMC0wMDAwODI2ZGEzXQogIFswMDAwODI2ZGIw
LTAwMDA4MjZkYjNdCiAgWzAwMDA4MjZkYzAtMDAwMDgyNmRjM10KICBbMDAwMDgyNmRkMC0w
MDAwODI3ZTQ1XQogIFswMDAwODI3ZTUwLTAwMDA4MjdlYzVdCiAgWzAwMDA4MjdlZDAtMDAw
MDgyN2ZhM10KICBbMDAwMDgyN2ZiMC0wMDAwODI3ZmYzXQogIFswMDAwODI4MDAwLTAwMDA4
M2ZmZmZdCk1lbW9yeTogNTExMmsvODQ0OGsgYXZhaWxhYmxlICgyMDIyayBrZXJuZWwgY29k
ZSwgMjg4NGsgcmVzZXJ2ZWQsIDM5MmsgZGF0YSwgMjEyayBpbml0LCAwayBoaWdobWVtKQp2
aXJ0dWFsIGtlcm5lbCBtZW1vcnkgbGF5b3V0OgogICAgZml4bWFwICA6IDB4ZmZmZTQwMDAg
LSAweGZmZmZmMDAwICAgKCAxMDgga0IpCiAgICB2bWFsbG9jIDogMHhjMTA0MDAwMCAtIDB4
ZmZmZTIwMDAgICAoMTAwNyBNQikKICAgIGxvd21lbSAgOiAweGMwMDAwMDAwIC0gMHhjMDg0
MDAwMCAgICggICA4IE1CKQogICAgICAuaW5pdCA6IDB4YzA2NWMwMDAgLSAweGMwNjkxMDAw
ICAgKCAyMTIga0IpCiAgICAgIC5kYXRhIDogMHhjMDVmOWE1YiAtIDB4YzA2NWJlNTAgICAo
IDM5MiBrQikKICAgICAgLnRleHQgOiAweGMwNDAwMDAwIC0gMHhjMDVmOWE1YiAgICgyMDIy
IGtCKQpDaGVja2luZyBpZiB0aGlzIHByb2Nlc3NvciBob25vdXJzIHRoZSBXUCBiaXQgZXZl
biBpbiBzdXBlcnZpc29yIG1vZGUuLi5Pay4KU0xVQjogR2Vuc2xhYnM9MTUsIEhXYWxpZ249
MzIsIE9yZGVyPTAtMywgTWluT2JqZWN0cz0wLCBDUFVzPTEsIE5vZGVzPTEKTlJfSVJRUzox
NgpDUFUgMCBpcnFzdGFja3MsIGhhcmQ9YzA4MTIwMDAgc29mdD1jMDgxNDAwMApDb25zb2xl
OiBjb2xvdXIgVkdBKyA4MHgyNQpjb25zb2xlIFt0dHkwXSBlbmFibGVkLCBib290Y29uc29s
ZSBkaXNhYmxlZAr/
--------------010202020300070101070404--
