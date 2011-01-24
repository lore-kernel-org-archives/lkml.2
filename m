Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab1AXDGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 22:06:36 -0500
Received: from m12-12.163.com ([220.181.12.12]:56646 "EHLO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab1AXDGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 22:06:35 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jan 2011 22:06:34 EST
Message-ID: <BAE8B1D5C66746F5A2ABEA338733E711@corp89a2939dea>
From: "zhiping zhong" <xzhong86@163.com>
To: "Steven Rostedt" <srostedt@redhat.com>
Cc: "wu zhangjin" <wuzhangjin@gmail.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <AANLkTinxxOsXNatAiP0t8Vv0xFZcdSpoWWrG49g6JjqF@mail.gmail.com> <1295544654.19789.19.camel@fedora> <AANLkTin6g8SGnuG6j6JVCdBvOeiBj8Quwr2T9K+3jUwq@mail.gmail.com> <1295635231.26768.2.camel@fedora>
Subject: Re: [BUG?] tracing/function_graph: set_graph_function was broken
Date: Mon, 24 Jan 2011 10:47:46 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4657
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4657
X-CM-TRANSID: DMCowLDrZZQu6DxNiQk2AA--.3200S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Xr18AFyxGw1xAr4Uur1Utrb_yoWxKrWxpr
	yft3yakw4kGrWIgr4xJF18ur1UJr47ZrW5Arnakan5Z3s8ZrWUJw1UKF18J34UCa4kA3y7
	W3Zayw1kKay7u37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UTwZcUUUUU=
X-CM-SenderInfo: p02k00rjywqiywtou0bp/xtbBiA7QD0kZ1X6xnAAAsP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0O36x9i028224

Hi, Steve

    Here is the example:
    We use the tracer "function_graph",set the graph function as "sys_nanosleep",then do nathing just wait.
    $ echo 0 > tracing_enable
    $ echo function_graph > current_tracer
    $ echo sys_nanosleep > set_graph_function
    $ echo "" > trace
    $ echo 1 > tracing_enable
        [ ... wait a few second ]
    $ echo 0 > tracing_enable
    $ cat trace
        [ now, we kan saw the function "plat_irq_dispatch" was traced ]
    [ I did this on a platform based on jz4760 which is a MIPS compatible cpu ]
    
    I append the full shell information at the tail of this letter.
    
    The cause of this problem is:
----------------------- key code ------------------------
        [snip] in prepare_ftrace_return()
<1>      if (ftrace_push_return_trace(old, self_addr, &trace.depth, fp) ==
             -EBUSY) {
              *parent = old;
              return;
         }

         trace.func = self_addr;

         /* Only trace if the calling function expects to */
<2>      if (!ftrace_graph_entry(&trace)) {
              current->curr_ret_stack--;
              *parent = old;
         }
        [snip]

        [snip] in trace_graph_entry()
        /* trace it when it is-nested-in or is a function enabled. */
<3>     if (!(trace->depth || ftrace_graph_addr(trace->func)) ||
              ftrace_graph_ignore_irqs())
                return 0;
        [snip]
------------------ code end -------------------------
    
    when a interruption occured between <1> and <2>, the interruption entry function "plat_irq_dispatch"
will get the trace.depth = 1, because the function which was interrupted take the trace.depth = 0(trace.depth
was initialized with value -1), then the "plat_irq_dispatch" function reached <3>, because it takes trace->depth=1,
so the two condition followed utterly useless, function "plat_irq_dispatch" will be traceed completely.
    
    In the old kernel version like 2.6.31, you use function set_tsk_trace_graph() and clear_tsk_trace_graph()
to start and end tracing, but in 2.6.36(or earlier) version, you use trace->depth  instead, and cause this problem.
    
    
    My English is not good, but please bear with me.
    
Regards,
    zhong zhiping
  

------------ The full shell info, please copy into notepad for more readability --------------
bash-3.2# cat current_tracer 
function_graph
bash-3.2# cat set_graph_function 
sys_nanosleep
bash-3.2# echo "" > tracing
bash: tracing: Permission denied
bash-3.2# echo "" > trace
bash-3.2# cat trace
# tracer: function_graph
#
# CPU  DURATION                  FUNCTION CALLS
# |     |   |                     |   |   |   |
bash-3.2# echo 1 > tracing_enabled 
bash-3.2# echo 0 > tracing_enabled 
bash-3.2# cat trace
# tracer: function_graph
#
# CPU  DURATION                  FUNCTION CALLS
# |     |   |                     |   |   |   |
 0)               |    plat_irq_dispatch() {
 0)   ==========> |
 0)               |      do_IRQ() {
 0)               |        irq_enter() {
 0)   0.000 us    |          idle_cpu();
 0)   0.000 us    |        }
 0)   0.000 us    |        irq_to_desc();
 0)               |        handle_level_irq() {
 0)   0.000 us    |          disable_intc_irq();
 0)   0.000 us    |          mask_and_ack_intc_irq();
 0)               |          handle_IRQ_event() {
 0)               |            jz_timer_interrupt() {
 0)   0.000 us    |              f4760_timer_callback();
 0)               |              tick_handle_periodic() {
 0)               |                tick_periodic() {
 0)               |                  do_timer() {
 0)               |                    update_wall_time() {
 0)   0.000 us    |                      jz_get_cycles();
 0)   0.000 us    |                    }
 0)   0.000 us    |                    calc_global_load();
 0) ! 10000.00 us |                  }
 0)               |                  update_process_times() {
 0)               |                    account_process_tick() {
 0)   0.000 us    |                      account_system_time();
 0)   0.000 us    |                    }
 0)               |                    run_local_timers() {
 0)   0.000 us    |                      hrtimer_run_queues();
 0)   0.000 us    |                      raise_softirq();
 0)   0.000 us    |                    }
 0)               |                    rcu_check_callbacks() {
 0)   0.000 us    |                      idle_cpu();
 0)               |                      __rcu_pending() {
 0)   0.000 us    |                        cpu_has_callbacks_ready_to_invoke();
 0)   0.000 us    |                        cpu_needs_another_gp();
 0)   0.000 us    |                        rcu_gp_in_progress();
 0)   0.000 us    |                      }
 0)               |                      __rcu_pending() {
 0)   0.000 us    |                        cpu_has_callbacks_ready_to_invoke();
 0)   0.000 us    |                        cpu_needs_another_gp();
 0)   0.000 us    |                        rcu_gp_in_progress();
 0)   0.000 us    |                      }
 0)   0.000 us    |                    }
 0)   0.000 us    |                    printk_tick();
 0)               |                    scheduler_tick() {
 0)   0.000 us    |                      task_tick_idle();
 0)   0.000 us    |                    }
 0)   0.000 us    |                    run_posix_cpu_timers();
 0)   0.000 us    |                  }
 0) ! 10000.00 us |                }
 0) ! 10000.00 us |              }
 0) ! 10000.00 us |            }
 0) ! 10000.00 us |          }
 0)   0.000 us    |          note_interrupt();
 0)   0.000 us    |          enable_intc_irq();
 0) ! 10000.00 us |        }
 0)   0.000 us    |        irq_exit();
 0) ! 10000.00 us |      }
 0)   <========== |
 0) ! 10000.00 us |    }
 0)               |    plat_irq_dispatch() {
 0)   ==========> |
 0)               |      do_IRQ() {
 0)               |        irq_enter() {
 0)   0.000 us    |          idle_cpu();
 0)   0.000 us    |        }
 0)   0.000 us    |        irq_to_desc();
 0)               |        handle_level_irq() {
 0)   0.000 us    |          disable_gpio_irq();
 0)   0.000 us    |          mask_and_ack_gpio_irq();
 0)               |          handle_IRQ_event() {
 0)               |            cirrus_interrupt() {
 0)               |              dev_alloc_skb() {
 0)               |                __alloc_skb() {
 0)   0.000 us    |                  kmem_cache_alloc();
 0)               |                  __kmalloc_track_caller() {
 0)   0.000 us    |                    get_slab();
 0)   0.000 us    |                  }
 0)   0.000 us    |                }
 0)   0.000 us    |              }
 0)   0.000 us    |              skb_put();
 0)   0.000 us    |              eth_type_trans();
 0)   0.000 us    |              netif_rx();
 0)   0.000 us    |            }
 0)   0.000 us    |          }
 0)   0.000 us    |          note_interrupt();
 0)               |          enable_gpio_irq() {
 0)   0.000 us    |            enable_intc_irq();
 0)   0.000 us    |          }
 0)   0.000 us    |        }
 0)   0.000 us    |        irq_exit();
 0)   0.000 us    |      }
 0)   <========== |
 0)   0.000 us    |    }
 0)               |    plat_irq_dispatch() {
 0)   ==========> |
 0)               |      do_IRQ() {
 0)               |        irq_enter() {
 0)   0.000 us    |          idle_cpu();
 0)   0.000 us    |        }
 0)   0.000 us    |        irq_to_desc();
 0)               |        handle_level_irq() {
 0)   0.000 us    |          disable_intc_irq();
 0)   0.000 us    |          mask_and_ack_intc_irq();
 0)               |          handle_IRQ_event() {
 0)               |            jz_timer_interrupt() {
 0)   0.000 us    |              f4760_timer_callback();
 0)               |              tick_handle_periodic() {
 0)               |                tick_periodic() {
 0)               |                  do_timer() {
 0)               |                    update_wall_time() {
 0)   0.000 us    |                      jz_get_cycles();
 0)   0.000 us    |                    }
 0)   0.000 us    |                    calc_global_load();
 0) ! 10000.00 us |                  }
 0)               |                  update_process_times() {
 0)               |                    account_process_tick() {
 0)   0.000 us    |                      account_system_time();
 0)   0.000 us    |                    }
 0)               |                    run_local_timers() {
 0)   0.000 us    |                      hrtimer_run_queues();
 0)   0.000 us    |                      raise_softirq();
 0)   0.000 us    |                    }
 0)               |                    rcu_check_callbacks() {
 0)   0.000 us    |                      idle_cpu();
 0)               |                      __rcu_pending() {
 0)   0.000 us    |                        cpu_has_callbacks_ready_to_invoke();
 0)   0.000 us    |                        cpu_needs_another_gp();
 0)   0.000 us    |                        rcu_gp_in_progress();
 0)   0.000 us    |                      }
 0)               |                      __rcu_pending() {
 0)   0.000 us    |                        cpu_has_callbacks_ready_to_invoke();
 0)   0.000 us    |                        cpu_needs_another_gp();
 0)   0.000 us    |                        rcu_gp_in_progress();
 0)   0.000 us    |                      }
 0)   0.000 us    |                    }
 0)   0.000 us    |                    printk_tick();
 0)               |                    scheduler_tick() {
 0)   0.000 us    |                      task_tick_idle();
 0)   0.000 us    |                    }
 0)   0.000 us    |                    run_posix_cpu_timers();
 0)   0.000 us    |                  }
 0) ! 10000.00 us |                }
 0) ! 10000.00 us |              }
 0) ! 10000.00 us |            }
 0) ! 10000.00 us |          }
 0)   0.000 us    |          note_interrupt();
 0)   0.000 us    |          enable_intc_irq();
 0) ! 10000.00 us |        }
 0)   0.000 us    |        irq_exit();
 0) ! 10000.00 us |      }
 0)   <========== |
 0) ! 10000.00 us |    }
 0)               |    plat_irq_dispatch() {
 0)   ==========> |
 0)               |      do_IRQ() {
 0)               |        irq_enter() {
 0)   0.000 us    |          idle_cpu();
 0)   0.000 us    |        }
 0)   0.000 us    |        irq_to_desc();
 0)               |        handle_level_irq() {
 0)   0.000 us    |          disable_gpio_irq();
 0)   0.000 us    |          mask_and_ack_gpio_irq();
 0)               |          handle_IRQ_event() {
 0)               |            cirrus_interrupt() {
 0)               |              dev_alloc_skb() {
 0)               |                __alloc_skb() {
 0)   0.000 us    |                  kmem_cache_alloc();
 0)               |                  __kmalloc_track_caller() {
 0)   0.000 us    |                    get_slab();
 0)   0.000 us    |                  }
 0)   0.000 us    |                }
 0)   0.000 us    |              }
 0)   0.000 us    |              skb_put();
 0)   0.000 us    |              eth_type_trans();
 0)   0.000 us    |              netif_rx();
 0)   0.000 us    |            }
 0)   0.000 us    |          }
 0)   0.000 us    |          note_interrupt();
 0)               |          enable_gpio_irq() {
 0)   0.000 us    |            enable_intc_irq();
 0)   0.000 us    |          }
 0)   0.000 us    |        }
 0)   0.000 us    |        irq_exit();
 0)   0.000 us    |      }
 0)   <========== |
 0)   0.000 us    |    }
bash-3.2# ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
