Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab1KOD4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 22:56:35 -0500
Received: from [85.183.114.52] ([85.183.114.52]:57638 "EHLO Dublin.logfs.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755346Ab1KOD4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 22:56:34 -0500
Date: Tue, 15 Nov 2011 04:57:34 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jens Axboe <jens.axboe@oracle.com>, Kashyap@logfs.org,
        Desai <kashyap.desai@lsi.com>, Steve Hodgson <steve@purestorage.com>
Subject: Why does a fire&forget IPI take 82us?
Message-ID: <20111115035734.GA14799@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Peter and Jens on Cc: as they foolishly last touched some of the code
in question. ]

Here is some fun behaviour.  In the irqsoff trace at the bottom of the
mail, you can notice substantial delays in
default_send_IPI_mask_sequence_phys().  If you sum them up, about
328us of the 399us, or 82% of the time, is spent in this function.  If
I don't completely misread the code, the culprit should be
__xapic_wait_icr_idle(), which basically does what the name implies -
it waits.

But a few lines up there is __blk_complete_request(), which
effectively initiates the IPI.  And it does that with this call:
		__smp_call_function_single(cpu, data, 0);

Notice the third parameter and compare with the function prototype:
void __smp_call_function_single(int cpuid, struct call_single_data *data,
				int wait);

So while I admittedly don't understand the code in question, it
appears to me as if the intent from the block layer was to
fire&forget.  A call to __smp_call_function_single() should not take
more than 1-2us.  But somewhere along the call chain - going from
generic_exec_single to native_send_call_func_single_ipi - the wait
parameter gets dropped and we end up waiting against explicitly
demanding the opposite.  And because I don't see an obvious reason to
drop the parameter, I suspect this might be undesired behaviour.

Comments?  Opinions?

Preemptive answers to potential questions:
- System is 2-socket 24-cpu Xeon E5645 @ 2.40GHz
- testcase to generate this trace was ~4000 parallel dds:
  time (for i in `seq 100`; do for DEV in /dev/sd[c-z] /dev/sda[a-z]; \
  do dd iflag=direct bs=512 of=/dev/null count=4k skip="$i"M if=$DEV& \
  done >& /dev/null; done; wait)
- mpt2sas should use tasklets.  I have a patch to that extend that
  cuts irqsoff time down to ~80us and seems to prevent long wait times
  as a side-effect.  Once I get a chance to polish it I will send it
  out.  However, I would still love to know why we ignore the "please
  don't wait" argument.

Jörn

-- 
Data expands to fill the space available for storage.
-- Parkinson's Law

# tracer: irqsoff
#
# irqsoff latency trace v1.1.5 on 2.6.39.3+
# --------------------------------------------------------------------
# latency: 399 us, #332/332, CPU#7 | (M:server VP:0, KP:0, SP:0 HP:0 #P:24)
#    -----------------
#    | task: dd-3198 (uid:0 nice:0 policy:0 rt_prio:0)
#    -----------------
#  => started at: save_args+0x6a/0x70
#  => ended at:   restore_args+0x0/0x30
#
#
#                  _------=> CPU#            
#                 / _-----=> irqs-off        
#                | / _----=> need-resched    
#                || / _---=> hardirq/softirq 
#                ||| / _--=> preempt-depth   
#                |||| /     delay             
#  cmd     pid   ||||| time  |   caller      
#     \   /      |||||  \    |   /           
      dd-3198    7d...    0us : trace_hardirqs_off_thunk+0x3a/0x6c <-save_args+0x6a/0x70
      dd-3198    7d...    0us : do_IRQ+0x18/0xe0 <-ret_from_intr+0x0/0x1a
      dd-3198    7d...    1us : exit_idle+0x4/0x50 <-do_IRQ+0x3e/0xe0
      dd-3198    7d...    1us : irq_enter+0x9/0x90 <-do_IRQ+0x43/0xe0
      dd-3198    7d...    1us : rcu_irq_enter+0x4/0x60 <-irq_enter+0x1b/0x90
      dd-3198    7d...    1us : idle_cpu+0x4/0x40 <-irq_enter+0x22/0x90
      dd-3198    7d.h.    2us : handle_irq+0x9/0x40 <-do_IRQ+0x5a/0xe0
      dd-3198    7d.h.    2us : irq_to_desc+0x4/0x20 <-handle_irq+0x15/0x40
      dd-3198    7d.h.    2us : handle_edge_irq+0x9/0x110 <-handle_irq+0x22/0x40
      dd-3198    7d.h.    3us : _raw_spin_lock+0x4/0x20 <-handle_edge_irq+0x1a/0x110
      dd-3198    7d.h.    3us : ir_ack_apic_edge+0x4/0x20 <-handle_edge_irq+0x4b/0x110
      dd-3198    7d.h.    3us : native_apic_mem_write+0x4/0x20 <-ir_ack_apic_edge+0x1d/0x20
      dd-3198    7d.h.    3us : handle_irq_event+0x14/0x60 <-handle_edge_irq+0x6f/0x110
      dd-3198    7d.h.    4us : handle_irq_event_percpu+0x11/0x240 <-handle_irq_event+0x3a/0x60
      dd-3198    7d.h.    4us : _base_interrupt+0x11/0x7b0 [mpt2sas] <-handle_irq_event_percpu+0x55/0x240
      dd-3198    7d.h.    5us : _scsih_io_done+0x1f/0xc50 [mpt2sas] <-_base_interrupt+0x1b7/0x7b0 [mpt2sas]
      dd-3198    7d.h.    5us : mpt2sas_base_get_reply_virt_addr+0x4/0x20 [mpt2sas] <-_scsih_io_done+0x31/0xc50 [mpt2sas]
      dd-3198    7d.h.    5us : _raw_spin_lock_irqsave+0x10/0x50 <-_scsih_io_done+0x48/0xc50 [mpt2sas]
      dd-3198    7d.h.    5us : _raw_spin_unlock_irqrestore+0x9/0x50 <-_scsih_io_done+0x83/0xc50 [mpt2sas]
      dd-3198    7d.h.    6us : mpt2sas_base_get_msg_frame+0x4/0x30 [mpt2sas] <-_scsih_io_done+0xa0/0xc50 [mpt2sas]
      dd-3198    7d.h.    6us : scsi_dma_unmap+0x4/0x60 <-_scsih_io_done+0x542/0xc50 [mpt2sas]
      dd-3198    7d.h.    6us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x18/0x50
      dd-3198    7d.h.    7us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x3c/0x50
      dd-3198    7d.h.    7us : scsi_done+0x18/0x80 <-_scsih_io_done+0x54b/0xc50 [mpt2sas]
      dd-3198    7d.h.    7us : blk_complete_request+0x4/0x30 <-scsi_done+0x31/0x80
      dd-3198    7d.h.    7us : __blk_complete_request+0x1c/0x1e0 <-blk_complete_request+0x25/0x30
      dd-3198    7d.h.    8us : __smp_call_function_single+0xd/0x110 <-__blk_complete_request+0x149/0x1e0
      dd-3198    7d.h.    8us : generic_exec_single+0x1c/0xb0 <-__smp_call_function_single+0x64/0x110
      dd-3198    7d.h.    8us : _raw_spin_lock_irqsave+0x10/0x50 <-generic_exec_single+0x48/0xb0
      dd-3198    7d.h.    8us : _raw_spin_unlock_irqrestore+0x9/0x50 <-generic_exec_single+0x6d/0xb0
      dd-3198    7d.h.    9us : native_send_call_func_single_ipi+0x4/0x40 <-generic_exec_single+0xa7/0xb0
      dd-3198    7d.h.    9us : physflat_send_IPI_mask+0x4/0x10 <-native_send_call_func_single_ipi+0x36/0x40
      dd-3198    7d.h.    9us : default_send_IPI_mask_sequence_phys+0x11/0x110 <-physflat_send_IPI_mask+0xe/0x10
      dd-3198    7d.h.    9us : mpt2sas_base_free_smid+0xd/0x260 [mpt2sas] <-_base_interrupt+0x3eb/0x7b0 [mpt2sas]
      dd-3198    7d.h.    9us : _raw_spin_lock_irqsave+0x10/0x50 <-mpt2sas_base_free_smid+0x27/0x260 [mpt2sas]
      dd-3198    7d.h.   10us : _raw_spin_unlock_irqrestore+0x9/0x50 <-mpt2sas_base_free_smid+0x12a/0x260 [mpt2sas]
      dd-3198    7d.h.   10us : _scsih_io_done+0x1f/0xc50 [mpt2sas] <-_base_interrupt+0x1b7/0x7b0 [mpt2sas]
      dd-3198    7d.h.   10us : mpt2sas_base_get_reply_virt_addr+0x4/0x20 [mpt2sas] <-_scsih_io_done+0x31/0xc50 [mpt2sas]
      dd-3198    7d.h.   10us : _raw_spin_lock_irqsave+0x10/0x50 <-_scsih_io_done+0x48/0xc50 [mpt2sas]
      dd-3198    7d.h.   10us : _raw_spin_unlock_irqrestore+0x9/0x50 <-_scsih_io_done+0x83/0xc50 [mpt2sas]
      dd-3198    7d.h.   10us : mpt2sas_base_get_msg_frame+0x4/0x30 [mpt2sas] <-_scsih_io_done+0xa0/0xc50 [mpt2sas]
      dd-3198    7d.h.   11us : scsi_dma_unmap+0x4/0x60 <-_scsih_io_done+0x542/0xc50 [mpt2sas]
      dd-3198    7d.h.   11us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x18/0x50
      dd-3198    7d.h.   11us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x3c/0x50
      dd-3198    7d.h.   11us : scsi_done+0x18/0x80 <-_scsih_io_done+0x54b/0xc50 [mpt2sas]
      dd-3198    7d.h.   11us : blk_complete_request+0x4/0x30 <-scsi_done+0x31/0x80
      dd-3198    7d.h.   11us : __blk_complete_request+0x1c/0x1e0 <-blk_complete_request+0x25/0x30
      dd-3198    7d.h.   12us : __smp_call_function_single+0xd/0x110 <-__blk_complete_request+0x149/0x1e0
      dd-3198    7d.h.   12us : generic_exec_single+0x1c/0xb0 <-__smp_call_function_single+0x64/0x110
      dd-3198    7d.h.   12us : _raw_spin_lock_irqsave+0x10/0x50 <-generic_exec_single+0x48/0xb0
      dd-3198    7d.h.   12us : _raw_spin_unlock_irqrestore+0x9/0x50 <-generic_exec_single+0x6d/0xb0
      dd-3198    7d.h.   12us : native_send_call_func_single_ipi+0x4/0x40 <-generic_exec_single+0xa7/0xb0
      dd-3198    7d.h.   12us : physflat_send_IPI_mask+0x4/0x10 <-native_send_call_func_single_ipi+0x36/0x40
      dd-3198    7d.h.   12us+: default_send_IPI_mask_sequence_phys+0x11/0x110 <-physflat_send_IPI_mask+0xe/0x10
      dd-3198    7d.h.   94us : mpt2sas_base_free_smid+0xd/0x260 [mpt2sas] <-_base_interrupt+0x3eb/0x7b0 [mpt2sas]
      dd-3198    7d.h.   95us : _raw_spin_lock_irqsave+0x10/0x50 <-mpt2sas_base_free_smid+0x27/0x260 [mpt2sas]
      dd-3198    7d.h.   95us : _raw_spin_unlock_irqrestore+0x9/0x50 <-mpt2sas_base_free_smid+0x12a/0x260 [mpt2sas]
      dd-3198    7d.h.   95us : _scsih_io_done+0x1f/0xc50 [mpt2sas] <-_base_interrupt+0x1b7/0x7b0 [mpt2sas]
      dd-3198    7d.h.   95us : mpt2sas_base_get_reply_virt_addr+0x4/0x20 [mpt2sas] <-_scsih_io_done+0x31/0xc50 [mpt2sas]
      dd-3198    7d.h.   95us : _raw_spin_lock_irqsave+0x10/0x50 <-_scsih_io_done+0x48/0xc50 [mpt2sas]
      dd-3198    7d.h.   95us : _raw_spin_unlock_irqrestore+0x9/0x50 <-_scsih_io_done+0x83/0xc50 [mpt2sas]
      dd-3198    7d.h.   96us : mpt2sas_base_get_msg_frame+0x4/0x30 [mpt2sas] <-_scsih_io_done+0xa0/0xc50 [mpt2sas]
      dd-3198    7d.h.   96us : scsi_dma_unmap+0x4/0x60 <-_scsih_io_done+0x542/0xc50 [mpt2sas]
      dd-3198    7d.h.   96us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x18/0x50
      dd-3198    7d.h.   96us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x3c/0x50
      dd-3198    7d.h.   96us : scsi_done+0x18/0x80 <-_scsih_io_done+0x54b/0xc50 [mpt2sas]
      dd-3198    7d.h.   96us : blk_complete_request+0x4/0x30 <-scsi_done+0x31/0x80
      dd-3198    7d.h.   97us : __blk_complete_request+0x1c/0x1e0 <-blk_complete_request+0x25/0x30
      dd-3198    7d.h.   97us : __smp_call_function_single+0xd/0x110 <-__blk_complete_request+0x149/0x1e0
      dd-3198    7d.h.   97us : generic_exec_single+0x1c/0xb0 <-__smp_call_function_single+0x64/0x110
      dd-3198    7d.h.   97us : _raw_spin_lock_irqsave+0x10/0x50 <-generic_exec_single+0x48/0xb0
      dd-3198    7d.h.   98us : _raw_spin_unlock_irqrestore+0x9/0x50 <-generic_exec_single+0x6d/0xb0
      dd-3198    7d.h.   98us : native_send_call_func_single_ipi+0x4/0x40 <-generic_exec_single+0xa7/0xb0
      dd-3198    7d.h.   98us : physflat_send_IPI_mask+0x4/0x10 <-native_send_call_func_single_ipi+0x36/0x40
      dd-3198    7d.h.   98us+: default_send_IPI_mask_sequence_phys+0x11/0x110 <-physflat_send_IPI_mask+0xe/0x10
      dd-3198    7d.h.  178us : mpt2sas_base_free_smid+0xd/0x260 [mpt2sas] <-_base_interrupt+0x3eb/0x7b0 [mpt2sas]
      dd-3198    7d.h.  178us : _raw_spin_lock_irqsave+0x10/0x50 <-mpt2sas_base_free_smid+0x27/0x260 [mpt2sas]
      dd-3198    7d.h.  178us : _raw_spin_unlock_irqrestore+0x9/0x50 <-mpt2sas_base_free_smid+0x12a/0x260 [mpt2sas]
      dd-3198    7d.h.  178us : _scsih_io_done+0x1f/0xc50 [mpt2sas] <-_base_interrupt+0x1b7/0x7b0 [mpt2sas]
      dd-3198    7d.h.  179us : mpt2sas_base_get_reply_virt_addr+0x4/0x20 [mpt2sas] <-_scsih_io_done+0x31/0xc50 [mpt2sas]
      dd-3198    7d.h.  179us : _raw_spin_lock_irqsave+0x10/0x50 <-_scsih_io_done+0x48/0xc50 [mpt2sas]
      dd-3198    7d.h.  179us : _raw_spin_unlock_irqrestore+0x9/0x50 <-_scsih_io_done+0x83/0xc50 [mpt2sas]
      dd-3198    7d.h.  179us : mpt2sas_base_get_msg_frame+0x4/0x30 [mpt2sas] <-_scsih_io_done+0xa0/0xc50 [mpt2sas]
      dd-3198    7d.h.  179us : scsi_dma_unmap+0x4/0x60 <-_scsih_io_done+0x542/0xc50 [mpt2sas]
      dd-3198    7d.h.  179us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x18/0x50
      dd-3198    7d.h.  179us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x3c/0x50
      dd-3198    7d.h.  180us : scsi_done+0x18/0x80 <-_scsih_io_done+0x54b/0xc50 [mpt2sas]
      dd-3198    7d.h.  180us : blk_complete_request+0x4/0x30 <-scsi_done+0x31/0x80
      dd-3198    7d.h.  180us : __blk_complete_request+0x1c/0x1e0 <-blk_complete_request+0x25/0x30
      dd-3198    7d.h.  180us : __smp_call_function_single+0xd/0x110 <-__blk_complete_request+0x149/0x1e0
      dd-3198    7d.h.  180us : generic_exec_single+0x1c/0xb0 <-__smp_call_function_single+0x64/0x110
      dd-3198    7d.h.  180us : _raw_spin_lock_irqsave+0x10/0x50 <-generic_exec_single+0x48/0xb0
      dd-3198    7d.h.  180us : _raw_spin_unlock_irqrestore+0x9/0x50 <-generic_exec_single+0x6d/0xb0
      dd-3198    7d.h.  181us : native_send_call_func_single_ipi+0x4/0x40 <-generic_exec_single+0xa7/0xb0
      dd-3198    7d.h.  181us : physflat_send_IPI_mask+0x4/0x10 <-native_send_call_func_single_ipi+0x36/0x40
      dd-3198    7d.h.  181us+: default_send_IPI_mask_sequence_phys+0x11/0x110 <-physflat_send_IPI_mask+0xe/0x10
      dd-3198    7d.h.  196us : mpt2sas_base_free_smid+0xd/0x260 [mpt2sas] <-_base_interrupt+0x3eb/0x7b0 [mpt2sas]
      dd-3198    7d.h.  196us : _raw_spin_lock_irqsave+0x10/0x50 <-mpt2sas_base_free_smid+0x27/0x260 [mpt2sas]
      dd-3198    7d.h.  196us : _raw_spin_unlock_irqrestore+0x9/0x50 <-mpt2sas_base_free_smid+0x12a/0x260 [mpt2sas]
      dd-3198    7d.h.  196us : _scsih_io_done+0x1f/0xc50 [mpt2sas] <-_base_interrupt+0x1b7/0x7b0 [mpt2sas]
      dd-3198    7d.h.  196us : mpt2sas_base_get_reply_virt_addr+0x4/0x20 [mpt2sas] <-_scsih_io_done+0x31/0xc50 [mpt2sas]
      dd-3198    7d.h.  196us : _raw_spin_lock_irqsave+0x10/0x50 <-_scsih_io_done+0x48/0xc50 [mpt2sas]
      dd-3198    7d.h.  197us : _raw_spin_unlock_irqrestore+0x9/0x50 <-_scsih_io_done+0x83/0xc50 [mpt2sas]
      dd-3198    7d.h.  197us : mpt2sas_base_get_msg_frame+0x4/0x30 [mpt2sas] <-_scsih_io_done+0xa0/0xc50 [mpt2sas]
      dd-3198    7d.h.  197us : scsi_dma_unmap+0x4/0x60 <-_scsih_io_done+0x542/0xc50 [mpt2sas]
      dd-3198    7d.h.  197us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x18/0x50
      dd-3198    7d.h.  198us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x3c/0x50
      dd-3198    7d.h.  198us : scsi_done+0x18/0x80 <-_scsih_io_done+0x54b/0xc50 [mpt2sas]
      dd-3198    7d.h.  198us : blk_complete_request+0x4/0x30 <-scsi_done+0x31/0x80
      dd-3198    7d.h.  198us : __blk_complete_request+0x1c/0x1e0 <-blk_complete_request+0x25/0x30
      dd-3198    7d.h.  199us : __smp_call_function_single+0xd/0x110 <-__blk_complete_request+0x149/0x1e0
      dd-3198    7d.h.  199us : generic_exec_single+0x1c/0xb0 <-__smp_call_function_single+0x64/0x110
      dd-3198    7d.h.  199us : _raw_spin_lock_irqsave+0x10/0x50 <-generic_exec_single+0x48/0xb0
      dd-3198    7d.h.  199us : _raw_spin_unlock_irqrestore+0x9/0x50 <-generic_exec_single+0x6d/0xb0
      dd-3198    7d.h.  200us : native_send_call_func_single_ipi+0x4/0x40 <-generic_exec_single+0xa7/0xb0
      dd-3198    7d.h.  200us : physflat_send_IPI_mask+0x4/0x10 <-native_send_call_func_single_ipi+0x36/0x40
      dd-3198    7d.h.  200us+: default_send_IPI_mask_sequence_phys+0x11/0x110 <-physflat_send_IPI_mask+0xe/0x10
      dd-3198    7d.h.  232us : mpt2sas_base_free_smid+0xd/0x260 [mpt2sas] <-_base_interrupt+0x3eb/0x7b0 [mpt2sas]
      dd-3198    7d.h.  233us : _raw_spin_lock_irqsave+0x10/0x50 <-mpt2sas_base_free_smid+0x27/0x260 [mpt2sas]
      dd-3198    7d.h.  233us : _raw_spin_unlock_irqrestore+0x9/0x50 <-mpt2sas_base_free_smid+0x12a/0x260 [mpt2sas]
      dd-3198    7d.h.  233us : _scsih_io_done+0x1f/0xc50 [mpt2sas] <-_base_interrupt+0x1b7/0x7b0 [mpt2sas]
      dd-3198    7d.h.  233us : mpt2sas_base_get_reply_virt_addr+0x4/0x20 [mpt2sas] <-_scsih_io_done+0x31/0xc50 [mpt2sas]
      dd-3198    7d.h.  233us : _raw_spin_lock_irqsave+0x10/0x50 <-_scsih_io_done+0x48/0xc50 [mpt2sas]
      dd-3198    7d.h.  233us : _raw_spin_unlock_irqrestore+0x9/0x50 <-_scsih_io_done+0x83/0xc50 [mpt2sas]
      dd-3198    7d.h.  234us : mpt2sas_base_get_msg_frame+0x4/0x30 [mpt2sas] <-_scsih_io_done+0xa0/0xc50 [mpt2sas]
      dd-3198    7d.h.  234us : scsi_dma_unmap+0x4/0x60 <-_scsih_io_done+0x542/0xc50 [mpt2sas]
      dd-3198    7d.h.  234us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x18/0x50
      dd-3198    7d.h.  234us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x3c/0x50
      dd-3198    7d.h.  234us : scsi_done+0x18/0x80 <-_scsih_io_done+0x54b/0xc50 [mpt2sas]
      dd-3198    7d.h.  234us : blk_complete_request+0x4/0x30 <-scsi_done+0x31/0x80
      dd-3198    7d.h.  235us : __blk_complete_request+0x1c/0x1e0 <-blk_complete_request+0x25/0x30
      dd-3198    7d.h.  235us : __smp_call_function_single+0xd/0x110 <-__blk_complete_request+0x149/0x1e0
      dd-3198    7d.h.  235us : generic_exec_single+0x1c/0xb0 <-__smp_call_function_single+0x64/0x110
      dd-3198    7d.h.  235us : _raw_spin_lock_irqsave+0x10/0x50 <-generic_exec_single+0x48/0xb0
      dd-3198    7d.h.  235us : _raw_spin_unlock_irqrestore+0x9/0x50 <-generic_exec_single+0x6d/0xb0
      dd-3198    7d.h.  235us : native_send_call_func_single_ipi+0x4/0x40 <-generic_exec_single+0xa7/0xb0
      dd-3198    7d.h.  236us : physflat_send_IPI_mask+0x4/0x10 <-native_send_call_func_single_ipi+0x36/0x40
      dd-3198    7d.h.  236us+: default_send_IPI_mask_sequence_phys+0x11/0x110 <-physflat_send_IPI_mask+0xe/0x10
      dd-3198    7d.h.  283us : mpt2sas_base_free_smid+0xd/0x260 [mpt2sas] <-_base_interrupt+0x3eb/0x7b0 [mpt2sas]
      dd-3198    7d.h.  283us : _raw_spin_lock_irqsave+0x10/0x50 <-mpt2sas_base_free_smid+0x27/0x260 [mpt2sas]
      dd-3198    7d.h.  283us : _raw_spin_unlock_irqrestore+0x9/0x50 <-mpt2sas_base_free_smid+0x12a/0x260 [mpt2sas]
      dd-3198    7d.h.  284us : _scsih_io_done+0x1f/0xc50 [mpt2sas] <-_base_interrupt+0x1b7/0x7b0 [mpt2sas]
      dd-3198    7d.h.  284us : mpt2sas_base_get_reply_virt_addr+0x4/0x20 [mpt2sas] <-_scsih_io_done+0x31/0xc50 [mpt2sas]
      dd-3198    7d.h.  284us : _raw_spin_lock_irqsave+0x10/0x50 <-_scsih_io_done+0x48/0xc50 [mpt2sas]
      dd-3198    7d.h.  284us : _raw_spin_unlock_irqrestore+0x9/0x50 <-_scsih_io_done+0x83/0xc50 [mpt2sas]
      dd-3198    7d.h.  284us : mpt2sas_base_get_msg_frame+0x4/0x30 [mpt2sas] <-_scsih_io_done+0xa0/0xc50 [mpt2sas]
      dd-3198    7d.h.  284us : scsi_dma_unmap+0x4/0x60 <-_scsih_io_done+0x542/0xc50 [mpt2sas]
      dd-3198    7d.h.  285us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x18/0x50
      dd-3198    7d.h.  285us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x3c/0x50
      dd-3198    7d.h.  285us : scsi_done+0x18/0x80 <-_scsih_io_done+0x54b/0xc50 [mpt2sas]
      dd-3198    7d.h.  285us : blk_complete_request+0x4/0x30 <-scsi_done+0x31/0x80
      dd-3198    7d.h.  285us : __blk_complete_request+0x1c/0x1e0 <-blk_complete_request+0x25/0x30
      dd-3198    7d.h.  286us : __smp_call_function_single+0xd/0x110 <-__blk_complete_request+0x149/0x1e0
      dd-3198    7d.h.  286us : generic_exec_single+0x1c/0xb0 <-__smp_call_function_single+0x64/0x110
      dd-3198    7d.h.  286us : _raw_spin_lock_irqsave+0x10/0x50 <-generic_exec_single+0x48/0xb0
      dd-3198    7d.h.  286us : _raw_spin_unlock_irqrestore+0x9/0x50 <-generic_exec_single+0x6d/0xb0
      dd-3198    7d.h.  287us : native_send_call_func_single_ipi+0x4/0x40 <-generic_exec_single+0xa7/0xb0
      dd-3198    7d.h.  287us : physflat_send_IPI_mask+0x4/0x10 <-native_send_call_func_single_ipi+0x36/0x40
      dd-3198    7d.h.  287us : default_send_IPI_mask_sequence_phys+0x11/0x110 <-physflat_send_IPI_mask+0xe/0x10
      dd-3198    7d.h.  287us : mpt2sas_base_free_smid+0xd/0x260 [mpt2sas] <-_base_interrupt+0x3eb/0x7b0 [mpt2sas]
      dd-3198    7d.h.  287us : _raw_spin_lock_irqsave+0x10/0x50 <-mpt2sas_base_free_smid+0x27/0x260 [mpt2sas]
      dd-3198    7d.h.  287us : _raw_spin_unlock_irqrestore+0x9/0x50 <-mpt2sas_base_free_smid+0x12a/0x260 [mpt2sas]
      dd-3198    7d.h.  288us : _scsih_io_done+0x1f/0xc50 [mpt2sas] <-_base_interrupt+0x1b7/0x7b0 [mpt2sas]
      dd-3198    7d.h.  288us : mpt2sas_base_get_reply_virt_addr+0x4/0x20 [mpt2sas] <-_scsih_io_done+0x31/0xc50 [mpt2sas]
      dd-3198    7d.h.  288us : _raw_spin_lock_irqsave+0x10/0x50 <-_scsih_io_done+0x48/0xc50 [mpt2sas]
      dd-3198    7d.h.  288us : _raw_spin_unlock_irqrestore+0x9/0x50 <-_scsih_io_done+0x83/0xc50 [mpt2sas]
      dd-3198    7d.h.  288us : mpt2sas_base_get_msg_frame+0x4/0x30 [mpt2sas] <-_scsih_io_done+0xa0/0xc50 [mpt2sas]
      dd-3198    7d.h.  289us : scsi_dma_unmap+0x4/0x60 <-_scsih_io_done+0x542/0xc50 [mpt2sas]
      dd-3198    7d.h.  289us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x18/0x50
      dd-3198    7d.h.  289us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x3c/0x50
      dd-3198    7d.h.  290us : scsi_done+0x18/0x80 <-_scsih_io_done+0x54b/0xc50 [mpt2sas]
      dd-3198    7d.h.  290us : blk_complete_request+0x4/0x30 <-scsi_done+0x31/0x80
      dd-3198    7d.h.  290us : __blk_complete_request+0x1c/0x1e0 <-blk_complete_request+0x25/0x30
      dd-3198    7d.h.  290us : __smp_call_function_single+0xd/0x110 <-__blk_complete_request+0x149/0x1e0
      dd-3198    7d.h.  291us : generic_exec_single+0x1c/0xb0 <-__smp_call_function_single+0x64/0x110
      dd-3198    7d.h.  291us : _raw_spin_lock_irqsave+0x10/0x50 <-generic_exec_single+0x48/0xb0
      dd-3198    7d.h.  291us : _raw_spin_unlock_irqrestore+0x9/0x50 <-generic_exec_single+0x6d/0xb0
      dd-3198    7d.h.  291us : native_send_call_func_single_ipi+0x4/0x40 <-generic_exec_single+0xa7/0xb0
      dd-3198    7d.h.  291us : physflat_send_IPI_mask+0x4/0x10 <-native_send_call_func_single_ipi+0x36/0x40
      dd-3198    7d.h.  291us : default_send_IPI_mask_sequence_phys+0x11/0x110 <-physflat_send_IPI_mask+0xe/0x10
      dd-3198    7d.h.  292us : mpt2sas_base_free_smid+0xd/0x260 [mpt2sas] <-_base_interrupt+0x3eb/0x7b0 [mpt2sas]
      dd-3198    7d.h.  292us : _raw_spin_lock_irqsave+0x10/0x50 <-mpt2sas_base_free_smid+0x27/0x260 [mpt2sas]
      dd-3198    7d.h.  292us : _raw_spin_unlock_irqrestore+0x9/0x50 <-mpt2sas_base_free_smid+0x12a/0x260 [mpt2sas]
      dd-3198    7d.h.  292us : _scsih_io_done+0x1f/0xc50 [mpt2sas] <-_base_interrupt+0x1b7/0x7b0 [mpt2sas]
      dd-3198    7d.h.  292us : mpt2sas_base_get_reply_virt_addr+0x4/0x20 [mpt2sas] <-_scsih_io_done+0x31/0xc50 [mpt2sas]
      dd-3198    7d.h.  292us : _raw_spin_lock_irqsave+0x10/0x50 <-_scsih_io_done+0x48/0xc50 [mpt2sas]
      dd-3198    7d.h.  293us : _raw_spin_unlock_irqrestore+0x9/0x50 <-_scsih_io_done+0x83/0xc50 [mpt2sas]
      dd-3198    7d.h.  293us : mpt2sas_base_get_msg_frame+0x4/0x30 [mpt2sas] <-_scsih_io_done+0xa0/0xc50 [mpt2sas]
      dd-3198    7d.h.  293us : scsi_dma_unmap+0x4/0x60 <-_scsih_io_done+0x542/0xc50 [mpt2sas]
      dd-3198    7d.h.  293us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x18/0x50
      dd-3198    7d.h.  293us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x3c/0x50
      dd-3198    7d.h.  293us : scsi_done+0x18/0x80 <-_scsih_io_done+0x54b/0xc50 [mpt2sas]
      dd-3198    7d.h.  293us : blk_complete_request+0x4/0x30 <-scsi_done+0x31/0x80
      dd-3198    7d.h.  294us : __blk_complete_request+0x1c/0x1e0 <-blk_complete_request+0x25/0x30
      dd-3198    7d.h.  294us : __smp_call_function_single+0xd/0x110 <-__blk_complete_request+0x149/0x1e0
      dd-3198    7d.h.  294us : generic_exec_single+0x1c/0xb0 <-__smp_call_function_single+0x64/0x110
      dd-3198    7d.h.  294us : _raw_spin_lock_irqsave+0x10/0x50 <-generic_exec_single+0x48/0xb0
      dd-3198    7d.h.  295us : _raw_spin_unlock_irqrestore+0x9/0x50 <-generic_exec_single+0x6d/0xb0
      dd-3198    7d.h.  295us : mpt2sas_base_free_smid+0xd/0x260 [mpt2sas] <-_base_interrupt+0x3eb/0x7b0 [mpt2sas]
      dd-3198    7d.h.  295us : _raw_spin_lock_irqsave+0x10/0x50 <-mpt2sas_base_free_smid+0x27/0x260 [mpt2sas]
      dd-3198    7d.h.  295us : _raw_spin_unlock_irqrestore+0x9/0x50 <-mpt2sas_base_free_smid+0x12a/0x260 [mpt2sas]
      dd-3198    7d.h.  296us : _scsih_io_done+0x1f/0xc50 [mpt2sas] <-_base_interrupt+0x1b7/0x7b0 [mpt2sas]
      dd-3198    7d.h.  296us : mpt2sas_base_get_reply_virt_addr+0x4/0x20 [mpt2sas] <-_scsih_io_done+0x31/0xc50 [mpt2sas]
      dd-3198    7d.h.  296us : _raw_spin_lock_irqsave+0x10/0x50 <-_scsih_io_done+0x48/0xc50 [mpt2sas]
      dd-3198    7d.h.  296us : _raw_spin_unlock_irqrestore+0x9/0x50 <-_scsih_io_done+0x83/0xc50 [mpt2sas]
      dd-3198    7d.h.  296us : mpt2sas_base_get_msg_frame+0x4/0x30 [mpt2sas] <-_scsih_io_done+0xa0/0xc50 [mpt2sas]
      dd-3198    7d.h.  296us : scsi_dma_unmap+0x4/0x60 <-_scsih_io_done+0x542/0xc50 [mpt2sas]
      dd-3198    7d.h.  297us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x18/0x50
      dd-3198    7d.h.  297us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x3c/0x50
      dd-3198    7d.h.  297us : scsi_done+0x18/0x80 <-_scsih_io_done+0x54b/0xc50 [mpt2sas]
      dd-3198    7d.h.  297us : blk_complete_request+0x4/0x30 <-scsi_done+0x31/0x80
      dd-3198    7d.h.  298us : __blk_complete_request+0x1c/0x1e0 <-blk_complete_request+0x25/0x30
      dd-3198    7d.h.  298us : __smp_call_function_single+0xd/0x110 <-__blk_complete_request+0x149/0x1e0
      dd-3198    7d.h.  298us : generic_exec_single+0x1c/0xb0 <-__smp_call_function_single+0x64/0x110
      dd-3198    7d.h.  298us : _raw_spin_lock_irqsave+0x10/0x50 <-generic_exec_single+0x48/0xb0
      dd-3198    7d.h.  299us : _raw_spin_unlock_irqrestore+0x9/0x50 <-generic_exec_single+0x6d/0xb0
      dd-3198    7d.h.  299us : native_send_call_func_single_ipi+0x4/0x40 <-generic_exec_single+0xa7/0xb0
      dd-3198    7d.h.  299us : physflat_send_IPI_mask+0x4/0x10 <-native_send_call_func_single_ipi+0x36/0x40
      dd-3198    7d.h.  299us+: default_send_IPI_mask_sequence_phys+0x11/0x110 <-physflat_send_IPI_mask+0xe/0x10
      dd-3198    7d.h.  329us : mpt2sas_base_free_smid+0xd/0x260 [mpt2sas] <-_base_interrupt+0x3eb/0x7b0 [mpt2sas]
      dd-3198    7d.h.  329us : _raw_spin_lock_irqsave+0x10/0x50 <-mpt2sas_base_free_smid+0x27/0x260 [mpt2sas]
      dd-3198    7d.h.  329us : _raw_spin_unlock_irqrestore+0x9/0x50 <-mpt2sas_base_free_smid+0x12a/0x260 [mpt2sas]
      dd-3198    7d.h.  329us : _scsih_io_done+0x1f/0xc50 [mpt2sas] <-_base_interrupt+0x1b7/0x7b0 [mpt2sas]
      dd-3198    7d.h.  330us : mpt2sas_base_get_reply_virt_addr+0x4/0x20 [mpt2sas] <-_scsih_io_done+0x31/0xc50 [mpt2sas]
      dd-3198    7d.h.  330us : _raw_spin_lock_irqsave+0x10/0x50 <-_scsih_io_done+0x48/0xc50 [mpt2sas]
      dd-3198    7d.h.  330us : _raw_spin_unlock_irqrestore+0x9/0x50 <-_scsih_io_done+0x83/0xc50 [mpt2sas]
      dd-3198    7d.h.  330us : mpt2sas_base_get_msg_frame+0x4/0x30 [mpt2sas] <-_scsih_io_done+0xa0/0xc50 [mpt2sas]
      dd-3198    7d.h.  330us : scsi_dma_unmap+0x4/0x60 <-_scsih_io_done+0x542/0xc50 [mpt2sas]
      dd-3198    7d.h.  331us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x18/0x50
      dd-3198    7d.h.  331us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x3c/0x50
      dd-3198    7d.h.  331us : scsi_done+0x18/0x80 <-_scsih_io_done+0x54b/0xc50 [mpt2sas]
      dd-3198    7d.h.  331us : blk_complete_request+0x4/0x30 <-scsi_done+0x31/0x80
      dd-3198    7d.h.  331us : __blk_complete_request+0x1c/0x1e0 <-blk_complete_request+0x25/0x30
      dd-3198    7d.h.  331us : __smp_call_function_single+0xd/0x110 <-__blk_complete_request+0x149/0x1e0
      dd-3198    7d.h.  331us : generic_exec_single+0x1c/0xb0 <-__smp_call_function_single+0x64/0x110
      dd-3198    7d.h.  332us : _raw_spin_lock_irqsave+0x10/0x50 <-generic_exec_single+0x48/0xb0
      dd-3198    7d.h.  332us : _raw_spin_unlock_irqrestore+0x9/0x50 <-generic_exec_single+0x6d/0xb0
      dd-3198    7d.h.  332us : native_send_call_func_single_ipi+0x4/0x40 <-generic_exec_single+0xa7/0xb0
      dd-3198    7d.h.  332us : physflat_send_IPI_mask+0x4/0x10 <-native_send_call_func_single_ipi+0x36/0x40
      dd-3198    7d.h.  332us : default_send_IPI_mask_sequence_phys+0x11/0x110 <-physflat_send_IPI_mask+0xe/0x10
      dd-3198    7d.h.  333us : mpt2sas_base_free_smid+0xd/0x260 [mpt2sas] <-_base_interrupt+0x3eb/0x7b0 [mpt2sas]
      dd-3198    7d.h.  333us : _raw_spin_lock_irqsave+0x10/0x50 <-mpt2sas_base_free_smid+0x27/0x260 [mpt2sas]
      dd-3198    7d.h.  333us : _raw_spin_unlock_irqrestore+0x9/0x50 <-mpt2sas_base_free_smid+0x12a/0x260 [mpt2sas]
      dd-3198    7d.h.  334us : _scsih_io_done+0x1f/0xc50 [mpt2sas] <-_base_interrupt+0x1b7/0x7b0 [mpt2sas]
      dd-3198    7d.h.  334us : mpt2sas_base_get_reply_virt_addr+0x4/0x20 [mpt2sas] <-_scsih_io_done+0x31/0xc50 [mpt2sas]
      dd-3198    7d.h.  334us : _raw_spin_lock_irqsave+0x10/0x50 <-_scsih_io_done+0x48/0xc50 [mpt2sas]
      dd-3198    7d.h.  334us : _raw_spin_unlock_irqrestore+0x9/0x50 <-_scsih_io_done+0x83/0xc50 [mpt2sas]
      dd-3198    7d.h.  335us : mpt2sas_base_get_msg_frame+0x4/0x30 [mpt2sas] <-_scsih_io_done+0xa0/0xc50 [mpt2sas]
      dd-3198    7d.h.  335us : scsi_dma_unmap+0x4/0x60 <-_scsih_io_done+0x542/0xc50 [mpt2sas]
      dd-3198    7d.h.  336us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x18/0x50
      dd-3198    7d.h.  336us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x3c/0x50
      dd-3198    7d.h.  336us : scsi_done+0x18/0x80 <-_scsih_io_done+0x54b/0xc50 [mpt2sas]
      dd-3198    7d.h.  336us : blk_complete_request+0x4/0x30 <-scsi_done+0x31/0x80
      dd-3198    7d.h.  337us : __blk_complete_request+0x1c/0x1e0 <-blk_complete_request+0x25/0x30
      dd-3198    7d.h.  338us : __smp_call_function_single+0xd/0x110 <-__blk_complete_request+0x149/0x1e0
      dd-3198    7d.h.  338us : generic_exec_single+0x1c/0xb0 <-__smp_call_function_single+0x64/0x110
      dd-3198    7d.h.  338us : _raw_spin_lock_irqsave+0x10/0x50 <-generic_exec_single+0x48/0xb0
      dd-3198    7d.h.  339us : _raw_spin_unlock_irqrestore+0x9/0x50 <-generic_exec_single+0x6d/0xb0
      dd-3198    7d.h.  339us : mpt2sas_base_free_smid+0xd/0x260 [mpt2sas] <-_base_interrupt+0x3eb/0x7b0 [mpt2sas]
      dd-3198    7d.h.  339us : _raw_spin_lock_irqsave+0x10/0x50 <-mpt2sas_base_free_smid+0x27/0x260 [mpt2sas]
      dd-3198    7d.h.  339us : _raw_spin_unlock_irqrestore+0x9/0x50 <-mpt2sas_base_free_smid+0x12a/0x260 [mpt2sas]
      dd-3198    7d.h.  340us : _scsih_io_done+0x1f/0xc50 [mpt2sas] <-_base_interrupt+0x1b7/0x7b0 [mpt2sas]
      dd-3198    7d.h.  340us : mpt2sas_base_get_reply_virt_addr+0x4/0x20 [mpt2sas] <-_scsih_io_done+0x31/0xc50 [mpt2sas]
      dd-3198    7d.h.  341us : _raw_spin_lock_irqsave+0x10/0x50 <-_scsih_io_done+0x48/0xc50 [mpt2sas]
      dd-3198    7d.h.  341us : _raw_spin_unlock_irqrestore+0x9/0x50 <-_scsih_io_done+0x83/0xc50 [mpt2sas]
      dd-3198    7d.h.  341us : mpt2sas_base_get_msg_frame+0x4/0x30 [mpt2sas] <-_scsih_io_done+0xa0/0xc50 [mpt2sas]
      dd-3198    7d.h.  341us : scsi_dma_unmap+0x4/0x60 <-_scsih_io_done+0x542/0xc50 [mpt2sas]
      dd-3198    7d.h.  342us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x18/0x50
      dd-3198    7d.h.  342us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x3c/0x50
      dd-3198    7d.h.  343us : scsi_done+0x18/0x80 <-_scsih_io_done+0x54b/0xc50 [mpt2sas]
      dd-3198    7d.h.  343us : blk_complete_request+0x4/0x30 <-scsi_done+0x31/0x80
      dd-3198    7d.h.  343us : __blk_complete_request+0x1c/0x1e0 <-blk_complete_request+0x25/0x30
      dd-3198    7d.h.  344us : __smp_call_function_single+0xd/0x110 <-__blk_complete_request+0x149/0x1e0
      dd-3198    7d.h.  344us : generic_exec_single+0x1c/0xb0 <-__smp_call_function_single+0x64/0x110
      dd-3198    7d.h.  345us : _raw_spin_lock_irqsave+0x10/0x50 <-generic_exec_single+0x48/0xb0
      dd-3198    7d.h.  345us : _raw_spin_unlock_irqrestore+0x9/0x50 <-generic_exec_single+0x6d/0xb0
      dd-3198    7d.h.  346us : native_send_call_func_single_ipi+0x4/0x40 <-generic_exec_single+0xa7/0xb0
      dd-3198    7d.h.  346us : physflat_send_IPI_mask+0x4/0x10 <-native_send_call_func_single_ipi+0x36/0x40
      dd-3198    7d.h.  346us : default_send_IPI_mask_sequence_phys+0x11/0x110 <-physflat_send_IPI_mask+0xe/0x10
      dd-3198    7d.h.  346us : mpt2sas_base_free_smid+0xd/0x260 [mpt2sas] <-_base_interrupt+0x3eb/0x7b0 [mpt2sas]
      dd-3198    7d.h.  347us : _raw_spin_lock_irqsave+0x10/0x50 <-mpt2sas_base_free_smid+0x27/0x260 [mpt2sas]
      dd-3198    7d.h.  347us : _raw_spin_unlock_irqrestore+0x9/0x50 <-mpt2sas_base_free_smid+0x12a/0x260 [mpt2sas]
      dd-3198    7d.h.  347us : _scsih_io_done+0x1f/0xc50 [mpt2sas] <-_base_interrupt+0x1b7/0x7b0 [mpt2sas]
      dd-3198    7d.h.  348us : mpt2sas_base_get_reply_virt_addr+0x4/0x20 [mpt2sas] <-_scsih_io_done+0x31/0xc50 [mpt2sas]
      dd-3198    7d.h.  348us : _raw_spin_lock_irqsave+0x10/0x50 <-_scsih_io_done+0x48/0xc50 [mpt2sas]
      dd-3198    7d.h.  348us : _raw_spin_unlock_irqrestore+0x9/0x50 <-_scsih_io_done+0x83/0xc50 [mpt2sas]
      dd-3198    7d.h.  348us : mpt2sas_base_get_msg_frame+0x4/0x30 [mpt2sas] <-_scsih_io_done+0xa0/0xc50 [mpt2sas]
      dd-3198    7d.h.  348us : scsi_dma_unmap+0x4/0x60 <-_scsih_io_done+0x542/0xc50 [mpt2sas]
      dd-3198    7d.h.  349us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x18/0x50
      dd-3198    7d.h.  349us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x3c/0x50
      dd-3198    7d.h.  349us : scsi_done+0x18/0x80 <-_scsih_io_done+0x54b/0xc50 [mpt2sas]
      dd-3198    7d.h.  350us : blk_complete_request+0x4/0x30 <-scsi_done+0x31/0x80
      dd-3198    7d.h.  350us : __blk_complete_request+0x1c/0x1e0 <-blk_complete_request+0x25/0x30
      dd-3198    7d.h.  350us : __smp_call_function_single+0xd/0x110 <-__blk_complete_request+0x149/0x1e0
      dd-3198    7d.h.  350us : generic_exec_single+0x1c/0xb0 <-__smp_call_function_single+0x64/0x110
      dd-3198    7d.h.  351us : _raw_spin_lock_irqsave+0x10/0x50 <-generic_exec_single+0x48/0xb0
      dd-3198    7d.h.  351us : _raw_spin_unlock_irqrestore+0x9/0x50 <-generic_exec_single+0x6d/0xb0
      dd-3198    7d.h.  351us : native_send_call_func_single_ipi+0x4/0x40 <-generic_exec_single+0xa7/0xb0
      dd-3198    7d.h.  351us : physflat_send_IPI_mask+0x4/0x10 <-native_send_call_func_single_ipi+0x36/0x40
      dd-3198    7d.h.  352us : default_send_IPI_mask_sequence_phys+0x11/0x110 <-physflat_send_IPI_mask+0xe/0x10
      dd-3198    7d.h.  352us : mpt2sas_base_free_smid+0xd/0x260 [mpt2sas] <-_base_interrupt+0x3eb/0x7b0 [mpt2sas]
      dd-3198    7d.h.  352us : _raw_spin_lock_irqsave+0x10/0x50 <-mpt2sas_base_free_smid+0x27/0x260 [mpt2sas]
      dd-3198    7d.h.  353us : _raw_spin_unlock_irqrestore+0x9/0x50 <-mpt2sas_base_free_smid+0x12a/0x260 [mpt2sas]
      dd-3198    7d.h.  353us : _scsih_io_done+0x1f/0xc50 [mpt2sas] <-_base_interrupt+0x1b7/0x7b0 [mpt2sas]
      dd-3198    7d.h.  354us : mpt2sas_base_get_reply_virt_addr+0x4/0x20 [mpt2sas] <-_scsih_io_done+0x31/0xc50 [mpt2sas]
      dd-3198    7d.h.  354us : _raw_spin_lock_irqsave+0x10/0x50 <-_scsih_io_done+0x48/0xc50 [mpt2sas]
      dd-3198    7d.h.  354us : _raw_spin_unlock_irqrestore+0x9/0x50 <-_scsih_io_done+0x83/0xc50 [mpt2sas]
      dd-3198    7d.h.  354us : mpt2sas_base_get_msg_frame+0x4/0x30 [mpt2sas] <-_scsih_io_done+0xa0/0xc50 [mpt2sas]
      dd-3198    7d.h.  355us : scsi_dma_unmap+0x4/0x60 <-_scsih_io_done+0x542/0xc50 [mpt2sas]
      dd-3198    7d.h.  355us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x18/0x50
      dd-3198    7d.h.  356us : __phys_addr+0x4/0x50 <-is_swiotlb_buffer+0x3c/0x50
      dd-3198    7d.h.  356us : scsi_done+0x18/0x80 <-_scsih_io_done+0x54b/0xc50 [mpt2sas]
      dd-3198    7d.h.  356us : blk_complete_request+0x4/0x30 <-scsi_done+0x31/0x80
      dd-3198    7d.h.  356us : __blk_complete_request+0x1c/0x1e0 <-blk_complete_request+0x25/0x30
      dd-3198    7d.h.  357us : __smp_call_function_single+0xd/0x110 <-__blk_complete_request+0x149/0x1e0
      dd-3198    7d.h.  357us : generic_exec_single+0x1c/0xb0 <-__smp_call_function_single+0x64/0x110
      dd-3198    7d.h.  357us : _raw_spin_lock_irqsave+0x10/0x50 <-generic_exec_single+0x48/0xb0
      dd-3198    7d.h.  358us : _raw_spin_unlock_irqrestore+0x9/0x50 <-generic_exec_single+0x6d/0xb0
      dd-3198    7d.h.  359us : native_send_call_func_single_ipi+0x4/0x40 <-generic_exec_single+0xa7/0xb0
      dd-3198    7d.h.  359us : physflat_send_IPI_mask+0x4/0x10 <-native_send_call_func_single_ipi+0x36/0x40
      dd-3198    7d.h.  359us+: default_send_IPI_mask_sequence_phys+0x11/0x110 <-physflat_send_IPI_mask+0xe/0x10
      dd-3198    7d.h.  397us : mpt2sas_base_free_smid+0xd/0x260 [mpt2sas] <-_base_interrupt+0x3eb/0x7b0 [mpt2sas]
      dd-3198    7d.h.  397us : _raw_spin_lock_irqsave+0x10/0x50 <-mpt2sas_base_free_smid+0x27/0x260 [mpt2sas]
      dd-3198    7d.h.  397us : _raw_spin_unlock_irqrestore+0x9/0x50 <-mpt2sas_base_free_smid+0x12a/0x260 [mpt2sas]
      dd-3198    7d.h.  398us : note_interrupt+0x1c/0x1e0 <-handle_irq_event_percpu+0xaf/0x240
      dd-3198    7d.h.  398us : _raw_spin_lock+0x4/0x20 <-handle_irq_event+0x45/0x60
      dd-3198    7d.h.  398us : irq_exit+0x4/0xb0 <-do_IRQ+0x63/0xe0
      dd-3198    7d...  399us : rcu_irq_exit+0x4/0xa0 <-irq_exit+0x4b/0xb0
      dd-3198    7d...  399us : idle_cpu+0x4/0x40 <-irq_exit+0x58/0xb0
      dd-3198    7d...  399us : trace_hardirqs_on_thunk+0x3a/0x3c <-restore_args+0x0/0x30
      dd-3198    7d...  400us : trace_hardirqs_on_caller+0xeb/0x100 <-restore_args+0x0/0x30
      dd-3198    7d...  400us : <stack trace>
 => trace_hardirqs_on_thunk+0x3a/0x3c
 => bio_add_page+0x53/0x60
 => dio_bio_add_page+0x2c/0xb0
 => dio_send_cur_page+0x4b/0xc0
 => __blockdev_direct_IO+0x92a/0xbf0
 => blkdev_direct_IO+0x57/0x60
 => generic_file_aio_read+0x6e9/0x760
 => do_sync_read+0xd2/0x110
