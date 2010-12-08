Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab0LHQkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:40:23 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40404 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607Ab0LHQkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:40:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOtD/0x5LdBk/2dsb2JhbACjXHnAUIVJBA
Date: Thu, 9 Dec 2010 03:40:15 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: buggy perf callgraph output
Message-ID: <20101208164015.GA5444@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get strange looking perf output with the callchain hits not sorted
properly for graph and fractal:

     7.34%          open  [kernel.kallsyms]     [k] kmem_cache_alloc
                    |
                    --- kmem_cache_alloc
                       |          
                       |---0.05%-- get_empty_filp
                       |          do_filp_open
                       |          do_sys_open
                       |          sys_open
                       |          system_call
                       |          __open_nocancel
                       |          
                        ---0.16%-- getname
                                  do_sys_open
                                  sys_open
                                  system_call
                                  __open_nocancel

     6.17%          open  [kernel.kallsyms]     [k] _raw_spin_lock
                    |
                    --- _raw_spin_lock
                       |          
                       |---0.01%-- add_partial
                       |          __slab_free
                       |          kmem_cache_free
                       |          file_free_rcu
                       |          __rcu_process_callbacks
                       |          rcu_process_callbacks
                       |          __do_softirq
                       |          call_softirq
                       |          do_softirq
                       |          irq_exit
                       |          smp_apic_timer_interrupt
                       |          apic_timer_interrupt
                       |          
                       |---0.16%-- dput
                       |          |          
                       |           --0.57%-- fput
                       |                     filp_close
                       |                     sys_close
                       |                     system_call
                       |                     __libc_close
                       |          
                       |--0.60%-- link_path_walk
                       |          do_path_lookup
                       |          do_filp_open
                       |          do_sys_open
                       |          sys_open
                       |          system_call
                       |          __open_nocancel
                       |          
                       |--0.57%-- __slab_free
                       |          kmem_cache_free
                       |          file_free_rcu
                       |          __rcu_process_callbacks
                       |          rcu_process_callbacks
                       |          __do_softirq


With flat it looks a bit better:
     7.34%          open  [kernel.kallsyms]     [k] kmem_cache_alloc
             6.09%
                kmem_cache_alloc
                get_empty_filp
                do_filp_open
                do_sys_open
                sys_open
                system_call
                __open_nocancel

             1.07%
                kmem_cache_alloc
                getname
                do_sys_open
                sys_open
                system_call
                __open_nocancel

     6.17%          open  [kernel.kallsyms]     [k] _raw_spin_lock
             0.60%
                _raw_spin_lock
                link_path_walk
                do_path_lookup
                do_filp_open
                do_sys_open
                sys_open
                system_call
                __open_nocancel

             0.57%
                _raw_spin_lock
                fd_install
                do_sys_open
                sys_open
                system_call
                __open_nocancel

             0.57%
                _raw_spin_lock
                dput
                fput
                filp_close
                sys_close
                system_call
                __libc_close

