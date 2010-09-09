Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0IIQQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 12:16:38 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34266 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0IIQQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 12:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=SMVdZtRCyL1cAg0Xh8rgKP7XO4jyC7mYvROcQQXa6Rrqnv0Vckewu/cNFdzVukHewD
         IMnu6qKatij4j/Z/6oRRf5OFx5Z3GVYOMTfhyqc9qg2hsJBrzHP+426b63SaJpmb6Z8F
         8vrdot2UK+mPXqD14C+KIIGLbby064MK23ZME=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20100909082331.7278e76b.randy.dunlap@oracle.com>
References: <AANLkTi=uzLJxDbd+uJAww-b5aP10gd8gbGVG19HS46ue@mail.gmail.com>
	<20100909082331.7278e76b.randy.dunlap@oracle.com>
Date: Thu, 9 Sep 2010 18:16:04 +0200
Message-ID: <AANLkTi=KQ1HJ8s7NcTGHRKsj+wriH4uqWUi43LZnqUFv@mail.gmail.com>
Subject: Re: mm/Kconfig: warning: (COMPACTION && EXPERIMENTAL && HUGETLB_PAGE
 && MMU) selects MIGRATION which has unmet direct dependencies (NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 5:23 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Thu, 9 Sep 2010 17:10:34 +0200 Sedat Dilek wrote:
>
>> Hi,
>>
>> while build latest 2.6.36-rc3 I get this warning:
>>
>> [ build.log]
>> ...
>> warning: (COMPACTION && EXPERIMENTAL && HUGETLB_PAGE && MMU) selects
>> MIGRATION which has unmet direct dependencies (NUMA ||
>> ARCH_ENABLE_MEMORY_HOTREMOVE)
>> ...
>>
>> Here the excerpt of...
>>
>> [ mm/Kconfig ]
>> ...
>> # support for memory compaction
>> config COMPACTION
>>         bool "Allow for memory compaction"
>>         select MIGRATION
>>         depends on EXPERIMENTAL && HUGETLB_PAGE && MMU
>>         help
>>           Allows the compaction of memory for the allocation of huge pages.
>> ...
>>
>> I have set the following kernel-config parameters:
>>
>> $ egrep 'COMPACTION|HUGETLB_PAGE|MMU|MIGRATION|NUMA|ARCH_ENABLE_MEMORY_HOTREMOVE'
>> linux-2.6.36-rc3/debian/build/build_i386_none_686/.config
>> CONFIG_MMU=y
>> # CONFIG_IOMMU_HELPER is not set
>> CONFIG_IOMMU_API=y
>> CONFIG_COMPACTION=y
>> CONFIG_MIGRATION=y
>> CONFIG_MMU_NOTIFIER=y
>> CONFIG_HUGETLB_PAGE=y
>> # CONFIG_IOMMU_STRESS is not set
>>
>> Looks like I have no NUMA or ARCH_ENABLE_MEMORY_HOTREMOVE set.
>>
>> Ok, it is a *warning*...
>
>
> Andrea Arcangeli posted a patch for this on linux-mm on 2010-SEP-03.
> (below)
>
> ---
> From: Andrea Arcangeli <aarcange@redhat.com>
>
> COMPACTION enables MIGRATION, but MIGRATION spawns a warning if numa
> or memhotplug aren't selected. However MIGRATION doesn't depend on
> them. I guess it's just trying to be strict doing a double check on
> who's enabling it, but it doesn't know that compaction also enables
> MIGRATION.
>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -189,7 +189,7 @@ config COMPACTION
>  config MIGRATION
>        bool "Page migration"
>        def_bool y
> -       depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE
> +       depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE || COMPACTION
>        help
>          Allows the migration of the physical location of pages of processes
>          while the virtual addresses are not changed. This is useful in
>

Below is the URL for...

"[PATCH] avoid warning when COMPACTION is selected"

- Sedat -

[1] http://marc.info/?l=linux-mm&m=128352833826498&w=2
