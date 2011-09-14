Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab1INKxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 06:53:22 -0400
Received: from lucidpixels.com ([72.73.18.11]:35905 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab1INKxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 06:53:21 -0400
Date: Wed, 14 Sep 2011 06:53:20 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Lin Ming <mlin@ss.pku.edu.cn>, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        Andrew Morton <akpm@google.com>
Subject: Re: 3.0.1: pagevec_lookup+0x1d/0x30, SLAB issues?
In-Reply-To: <1315995608.2361.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.02.1109140629300.29782@p34.internal.lan>
References: <alpine.DEB.2.02.1109111815520.19558@p34.internal.lan>  <alpine.DEB.2.02.1109111837200.19558@p34.internal.lan>  <CAF1ivSZQ=KKC0gAk93eMVwLSCbeEWr=k6YszuE=sb1+Ue521vw@mail.gmail.com>  <alpine.DEB.2.02.1109140543590.29782@p34.internal.lan>
 <1315995608.2361.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-2143563782-1315996338=:29782"
Content-ID: <alpine.DEB.2.02.1109140653060.7308@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-2143563782-1315996338=:29782
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.02.1109140653061.7308@p34.internal.lan>



On Wed, 14 Sep 2011, Eric Dumazet wrote:

> Le mercredi 14 septembre 2011 =E0 05:47 -0400, Justin Piszcz a =E9crit :
>>
>> On Wed, 14 Sep 2011, Lin Ming wrote:
>>
>>> On Mon, Sep 12, 2011 at 6:44 AM, Justin Piszcz <jpiszcz@lucidpixels.com=
> wrote:
>>> Hi, Justin
>>>
>>> There is a similar bug report at:
>>> http://marc.info/?t=3D131594190600005&r=3D1&w=3D2
>>>
>>> The attached patch from Shaohua fixed the bug.
>>>
>>> Could you have a try it?
>>>
>>
>> Hi Lin/LKML,
>>
>> Can you please provide text patch files for what you want me to apply?
>> I did read that e-mail thread and that could be the culprit, I will patc=
h
>> and apply as soon as someone points to to the patch locations :)
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 645a080..7771871 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -827,13 +827,14 @@ unsigned find_get_pages(struct address_space *mappi=
ng, pgoff_t start,
> {
> =09unsigned int i;
> =09unsigned int ret;
> -=09unsigned int nr_found;
> +=09unsigned int nr_found, nr_skip;
>
> =09rcu_read_lock();
> restart:
> =09nr_found =3D radix_tree_gang_lookup_slot(&mapping->page_tree,
> =09=09=09=09(void ***)pages, NULL, start, nr_pages);
> =09ret =3D 0;
> +=09nr_skip =3D 0;
> =09for (i =3D 0; i < nr_found; i++) {
> =09=09struct page *page;
> repeat:
> @@ -856,6 +857,7 @@ repeat:
> =09=09=09 * here as an exceptional entry: so skip over it -
> =09=09=09 * we only reach this from invalidate_mapping_pages().
> =09=09=09 */
> +=09=09=09nr_skip++;
> =09=09=09continue;
> =09=09}
>
> @@ -876,7 +878,7 @@ repeat:
> =09 * If all entries were removed before we could secure them,
> =09 * try again, because callers stop trying once 0 is returned.
> =09 */
> -=09if (unlikely(!ret && nr_found))
> +=09if (unlikely(!ret && nr_found > nr_skip))
> =09=09goto restart;
> =09rcu_read_unlock();
> =09return ret;
>
>

Hi,

Thanks-- patch applied and booted to the new kernel, so just so everyone kn=
ows, I am running three patches atop of 3.1-rc4:

(for the igb problem/memory allocation issue)
0001-Fix-pointer-dereference-before-call-to-pcie_bus_conf.patch
0002-PCI-Remove-MRRS-modification-from-MPS-setting-code.patch

(for the RCU/memory errors)
0003-filemap.patch

I will try to perform more load tests on the NIC and CPU/MEM/I+O and see
if any of my problems return!

Justin.

--655872-2143563782-1315996338=:29782--
