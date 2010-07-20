Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454Ab0GTTSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 15:18:15 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33205 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758567Ab0GTTSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 15:18:12 -0400
Subject: Re: [PATCH 4/8] v3 Allow memory_block to span multiple memory
 sections
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, greg@kroah.com
In-Reply-To: <4C451E1C.8070907@austin.ibm.com>
References: <4C451BF5.50304@austin.ibm.com>
	 <4C451E1C.8070907@austin.ibm.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 20 Jul 2010 12:18:01 -0700
Message-ID: <1279653481.9785.4.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-19 at 22:55 -0500, Nathan Fontenot wrote:
> +static int add_memory_section(int nid, struct mem_section *section,
> +                       unsigned long state, enum mem_add_context context)
> +{
> +       struct memory_block *mem;
> +       int ret = 0;
> +
> +       mem = find_memory_block(section);
> +       if (mem) {
> +               atomic_inc(&mem->section_count);
> +               kobject_put(&mem->sysdev.kobj);
> +       } else
> +               ret = init_memory_block(&mem, section, state);
> +
>         if (!ret) {
> -               if (context == HOTPLUG)
> +               if (context == HOTPLUG &&
> +                   atomic_read(&mem->section_count) == sections_per_block)
>                         ret = register_mem_sect_under_node(mem, nid);
>         } 

I think the atomic_inc() can race with the atomic_dec_and_test() in
remove_memory_block().

Thread 1 does:

	mem = find_memory_block(section);

Thread 2 does 

	atomic_dec_and_test(&mem->section_count);

and destroys the memory block,  Thread 1 runs again:
	
       if (mem) {
               atomic_inc(&mem->section_count);
               kobject_put(&mem->sysdev.kobj);
       } else

but now mem got destroyed by Thread 2.  You probably need to change
find_memory_block() to itself take a reference, and to use
atomic_inc_unless().

-- Dave

