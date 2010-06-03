Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0FCUBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:01:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750873Ab0FCUBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:01:42 -0400
Date: Thu, 3 Jun 2010 12:56:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@vyatta.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: floppy driver assumes INITIAL_JIFFIES == 0
In-Reply-To: <20100603120313.10a73b20@nehalam>
Message-ID: <alpine.LFD.2.00.1006031204470.8175@i5.linux-foundation.org>
References: <20100603101501.5e5d7148@nehalam> <alpine.LFD.2.00.1006031013060.8175@i5.linux-foundation.org> <20100603120313.10a73b20@nehalam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Stephen Hemminger wrote:
> 
> Example warning from 2.6.32 (VMware based regression system)
> 
> [  195.061209] floppy0: disk absent or changed during operation
> [  195.061655] end_request: I/O error, dev fd0, sector 2
> [  195.063860] Buffer I/O error on device fd0, logical block 1
> [  195.064650] lost page write due to I/O error on fd0
> [  195.067456] floppy0: disk absent or changed during operation
> [  195.067468] end_request: I/O error, dev fd0, sector 2
> [  195.068518] Buffer I/O error on device fd0, logical block 1
> [  195.069618] lost page write due to I/O error on fd0
> [  195.077148] ------------[ cut here ]------------
> [  195.077647] WARNING: at fs/buffer.c:1159 mark_buffer_dirty+0x20/0x7a()

So this warning doesn't say anything, just that the floppy driver 
failed. Whether that is due to emulation problems or not, who knows. Does 
it work reliably if INITIAL_JIFFIES == 0?

> On 2.6.32 example (KVM with livecd + empty floppy image) and debugging
> forced on:
> [..]
> [    9.724066] floppy0: calling disk change from set_dor
> [    9.726342] floppy0: checking disk change line for drive 0
> [    9.728740] floppy0: jiffies=4294894728
> [    9.730566] floppy0: disk change line=0
> [    9.732371] floppy0: flags=20
> [   14.040103] end_request: I/O error, dev fd0, sector 2176
> [   14.041418] Buffer I/O error on device fd0, logical block 272
> [   14.042737] BUG: unable to handle kernel NULL pointer dereference at 00000040
> [   14.044052] IP: [<e08c2903>] floppy_ready+0x46f/0x4e3 [floppy]

Now _this_ is a kernel bug regardless. Oopsing is always bad.

It disassembles to

   0:	0f b6 05 c8 7b 8c e0 	movzbl 0xe08c7bc8,%eax
   7:	6b c0 34             	imul   $0x34,%eax,%eax
   a:	8d 90 e0 6d 8c e0    	lea    -0x1f739220(%eax),%edx
  10:	3e 80 a0 e0 6d 8c e0 	andb   $0xdf,%ds:-0x1f739220(%eax)
  17:	df 
  18:	0f b6 05 c8 7b 8c e0 	movzbl 0xe08c7bc8,%eax
  1f:	8b 15 00 72 8c e0    	mov    0xe08c7200,%edx
  25:	6b c0 34             	imul   $0x34,%eax,%eax
  28:*	8b 5a 40             	mov    0x40(%edx),%ebx     <-- trapping instruction
  2b:	0f bf 80 f2 6d 8c e0 	movswl -0x1f73920e(%eax),%eax
  32:	39 c3                	cmp    %eax,%ebx
  34:	74 56                	je     0x8c
  36:	80 3a 00             	cmpb   $0x0,(%edx)
  39:	79 51                	jns    0x8c

and I think it matches up with this code

        movzbl  current_drive, %eax     # current_drive, current_drive
        imull   $52, %eax, %eax #, current_drive, tmp253
        lock; andb $-33,drive_state(%eax)       #,
        movl    raw_cmd, %eax   # raw_cmd, raw_cmd.2563
        movzbl  current_drive, %edx     # current_drive, current_drive
        movl    64(%eax), %ebx  # <variable>.track, track
        imull   $52, %edx, %edx #, current_drive, tmp256
        movswl  drive_state+18(%edx), %edx      # <variable>.track, <variable>.track
        cmpl    %edx, %ebx      # <variable>.track, track

[ side note that odd '%ds:' override is because it's a locked instruction 
  that was turned into a non-locked one by turning the 'lock' prefix into 
  a 'ds' prefix instead - it looks odd, but it's just from running a SMP 
  kernel on a UP virtual machine ]

and that in turn seems to be from check_wp() (that "lock; andb" is the 
"clear_bit(FD_DISK_WRITABLE_BIT, &DRS->flags);" thing).

So I think we have floppy_ready() inlining seek_floppy(), and that in turn 
inlining check_wp(). And the actual oops seems to be just after the 
check_wp() function:
	
                if (raw_cmd->track != DRS->track &&
                    (raw_cmd->flags & FD_RAW_NEED_SEEK))
                        track = raw_cmd->track;
                else {
                        setup_rw_floppy();
                        return;
                }


because 'raw_cmd' is NULL. Which looks nonsensical, because we used 
"raw_cmd" earlier in floppy_ready().

But it does get cleared by interrupts. Possibly due to a much too early 
timeout, which would explain why that INITIAL_JIFFIES matters. Except 

> On 2.6.31 another example:
[...]
> [    7.623581] last redo_fd_request at 4294893446
> [    7.624731] 20  1 
> [    7.625595] status=80
> [    7.626305] fdc_busy=1
> [    7.627026] do_floppy=e085c053
> [    7.627856] cont=e08615dc
> [    7.628637] current_req=df813d48
> [    7.629567] command_status=-1
> [    7.630464] 
> [    7.631041] floppy0: floppy timeout called
> [    7.632137] end_request: I/O error, dev fd0, sector 2176
> [    7.634932] Buffer I/O error on device fd0, logical block 272
> [    7.636493] BUG: unable to handle kernel NULL pointer dereference at 00000004
> [    7.638225] IP: [<e0858d46>] reset_interrupt+0x41/0x45 [floppy]

This seems to be "cont->redo();", it decodes to

   f:	ff 70 08             	pushl  0x8(%eax)
  12:	68 d5 dc 85 e0       	push   $0xe085dcd5
  17:	e8 44 32 9b e0       	call   0xe09b3260
  1c:	a1 04 2f 86 e0       	mov    0xe0862f04,%eax
  21:	ff 50 08             	call   *0x8(%eax)
  24:	58                   	pop    %eax
  25:	5a                   	pop    %edx
  26:	a1 04 2f 86 e0       	mov    0xe0862f04,%eax
  2b:	ff 50 04             	call   *0x4(%eax)
  2e:	c3                   	ret    

and %eax is NULL. So "cont" is NULL. 

And both 'cont' and 'raw_cmd' are set to NULL in the same function: 
unlock_fdc(). So it does seem to be that we do that too early for some 
reason. But it _should_ happen only if there are no more requests in 
redo_fd_request().

But I don't see why. I'll dig around the timer stuff a bit more. If it 
only happens with that INITIAL_JIFFIES thing, it must be clearly somehow 
related to a timer happening (or not happening) too early.

			Linus
