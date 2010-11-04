Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab0KDXe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 19:34:56 -0400
Received: from nm29-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.236]:36075 "HELO
	nm29-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751330Ab0KDXey convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 19:34:54 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 404993.84990.bm@omp1010.mail.sp2.yahoo.com
Message-ID: <756314.4122.qm@web110514.mail.gq1.yahoo.com>
X-YMail-OSG: MDAOUQ4VM1nerLq4URs82dn10nhWoPNdAZA3HUdx9djwYOd
 LrxAv6ykr8SSNgLnwchL2etGpNa0xyFdzedsZdI8KXWBybe6U2KlhY2owaix
 B5xQ.TvfZnSWY3vwn1ysV6CVzxT610JXQ6kv3hpUqyYeInttw9hqomlk1fRW
 BRhEjDXtdoz7lDUcKOPW6.qFYIYUow_8oMtqvIGwmeJlqVwlef_DgQFT0hmu
 T9Kjb1_crpUK2N9dOxOtlV_._QY1YH171qoUy6DyfAScAUzVvar3UxdM6ibO
 FiBjSST.8_FumfE7LlIVo.UonIdroyL8OC3e87764Ff4fXuG4yFgjKcFxjTr
 flSetEeqE8XM70I2.HuMjF1BVSIrKkQtYchC3k658
X-RocketYMMF: multiplicador
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Thu, 4 Nov 2010 16:34:26 -0700 (PDT)
From: =?utf-8?B?QW5kcsOpIEx1aXMgUGVyZWlyYSBkb3MgU2FudG9zIC0gQlNSU29mdA==?= 
	<andre@bsrsoft.com.br>
Reply-To: andre@bsrsoft.com.br
Subject: Re: [PATCH 1/1] fs: Small refactoring of the code in ext4 2.6.37-rc1
To: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello.

This is true.
Despite having gone through all compilation and I have not noticed apparent problems, my mistake is evident in this case.

I had not realized that the side effect would really be changing variables incremented and decremented.

Thank you.

I'll think more about this type of side effect. :)


On Thu, 4 Nov 2010, André Luis Pereira dos Santos - BSRSoft wrote:

> From: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
>
> Hi.
> Small refactoring of the code in order to make minor enhancements to critical areas.
> The notation x + 1 has been replaced by more efficient notation x + +.
>
> Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
> ---
> Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
> --- linux-2.6.37-rc1/fs/ext4/extents.c        2010-11-01 09:54:12.000000000 -0200
> +++ linux-2.6.37-rc1-patched/fs/ext4/extents.c        2010-11-04 19:54:26.000000000 -0200
> @@ -555,9 +555,9 @@ ext4_ext_binsearch(struct inode *inode,
>       while (l <= r) {
>               m = l + (r - l) / 2;
>               if (block < le32_to_cpu(m->ee_block))
> -                     r = m - 1;
> +                     r = m--;
>               else
> -                     l = m + 1;
> +                     l = m++;

These do not give identical results.

foo = bar + 1;  assigns (bar + 1) to foo.
foo = bar--;  assigns bar to foo then decrements bar.
foo = --bar;  decrements bar then assigns bar to foo.

So your change both change the value that will be assigned to 'r' and 'l'
and also modify 'm' which was not previously modified.


>               ext_debug("%p(%u):%p(%u):%p(%u) ", l, le32_to_cpu(l->ee_block),
>                               m, le32_to_cpu(m->ee_block),
>                               r, le32_to_cpu(r->ee_block));
> @@ -1557,7 +1557,7 @@ static int ext4_ext_try_to_merge(struct
>               if (ext4_ext_is_uninitialized(ex))
>                       uninitialized = 1;
>               ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
> -                             + ext4_ext_get_actual_len(ex + 1));
> +                             + ext4_ext_get_actual_len(ex++));

After your change gcc complains:

 fs/ext4/extents.c:1559:16: warning: operation on ‘ex’ may be undefined
 fs/ext4/extents.c:1559:16: warning: operation on ‘ex’ may be undefined

which it is correct in doing since you are now modifying the value of the
pointer which is dereferenced in the assignment. Previously the value of
(ex+1) was simply passed to ext4_ext_get_actual_len(), but now you are
passing the value of (ex) to ext4_ext_get_actual_len() and then
subsequently incrementing 'ex' itself.


>               if (uninitialized)
>                       ext4_ext_mark_uninitialized(ex);
>
>


Was this patch even compile tested?


      
