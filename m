Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab1GJM7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 08:59:17 -0400
Received: from wnohang.net ([178.79.154.173]:32964 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756153Ab1GJM7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 08:59:15 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 42873F0007
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 3B0B9F0003
Date: Sun, 10 Jul 2011 18:29:09 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [TOME] Re: [PATCH 3/3] mm/readahead: Move the check for ra_pages
 after VM_SequentialReadHint()
Message-ID: <20110710125909.GA4460@Xye>
References: <cover.1310239575.git.rprabhu@wnohang.net>
 <323ddfc402a7f7b94f0cb02bba15acb2acca786f.1310239575.git.rprabhu@wnohang.net>
 <20110709205308.GC17463@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20110709205308.GC17463@localhost>
X-Operating-System: Arch linux x86_64 3.0.0-rc6-LYM
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

* On Sat, Jul 09, 2011 at 01:53:08PM -0700, Wu Fengguang <fengguang.wu@intel.com> wrote:
>On Sun, Jul 10, 2011 at 03:41:20AM +0800, Raghavendra D Prabhu wrote:
>> page_cache_sync_readahead checks for ra->ra_pages again, so moving the check after VM_SequentialReadHint.
>
>NAK. This patch adds nothing but overheads.
>
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -1566,8 +1566,6 @@ static void do_sync_mmap_readahead(struct vm_area_struct *vma,
>>  	/* If we don't want any read-ahead, don't bother */
>>  	if (VM_RandomReadHint(vma))
>>  		return;
>> -	if (!ra->ra_pages)
>> -		return;

>>  	if (VM_SequentialReadHint(vma)) {
>>  		page_cache_sync_readahead(mapping, ra, file, offset,
>> @@ -1575,6 +1573,9 @@ static void do_sync_mmap_readahead(struct vm_area_struct *vma,
>>  		return;
>>  	}

>> +	if (!ra->ra_pages)
>> +		return;
>> +
>
>page_cache_sync_readahead() has the same
>
>	if (!ra->ra_pages)
>		return;
1. Yes, I saw that and that is why I moved it after the condition, so that duplicate checks are
not needed -- ie., if VM_SequentialReadHint is true, then
(!ra->ra_pages) is checked twice otherwise.

2. Also, another thought, is the check needed at its original place (if
not it can be removed), reasons being -- filesystems like tmpfs which
have ra_pages set to 0 don't use filemap_fault in their VMA ops and also
do_sync_mmap_readahead is called in a major page fault context.
>
>So the patch adds the call into page_cache_sync_readahead() just to return..
>
>Thanks,
>Fengguang
>
--------------------------
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQEcBAEBAgAGBQJOGaIdAAoJEKYW3KHXK+l3q2AH/2JuXetggImM2X/RLTpPkaAJ
/fz5doPJXng4Ix5xU0axJ/3BF9tPH5dyzZ2NEas4lnzD/fP9+w39bU6BxoExf6Fs
0ipoduw4bT0Mi1Rav/PcoePCebrsSNprYIVdKW1r+hVTULzu5VZt+27zUoD1xJI4
byj3uKvJCfcpwqPwYrLjnszMo+iZXiQ72RPwvxXHwx7YA0oJBgnp6d0dIhXhCnoc
ikuvuU5Zl+HW5ehzUbQJNtHJj6lHkirCoRCbjsuBISyLtGRJnIo2OplMz3MfvAoB
j5fmdE16PZEFk9/lpaTwlXJ4UdrLIWkfbq0cfkHrCee9fCZa+nxcI5KHCn1D3LU=
=fTuG
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
