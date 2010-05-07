Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab0EGVoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:44:11 -0400
Received: from fifo99.com ([67.223.236.141]:56895 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab0EGVoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:44:08 -0400
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
From: Daniel Walker <dwalker@fifo99.com>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: Matthew Garrett <mjg@redhat.com>, Tony Lindgren <tony@atomide.com>,
       Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <p2vd6200be21005071435hf75ed42dnff2c2c02118e97@mail.gmail.com>
References: <20100507180152.GH387@atomide.com>
	 <20100507184621.GA25978@srcf.ucam.org>
	 <1273259186.3542.93.camel@c-dwalke-linux.qualcomm.com>
	 <20100507192837.GM387@atomide.com> <20100507193353.GA27175@srcf.ucam.org>
	 <20100507195548.GN387@atomide.com> <20100507202859.GA27328@srcf.ucam.org>
	 <20100507205329.GP387@atomide.com> <20100507210304.GA28701@srcf.ucam.org>
	 <1273267820.3542.120.camel@c-dwalke-linux.qualcomm.com>
	 <p2vd6200be21005071435hf75ed42dnff2c2c02118e97@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 14:43:57 -0700
Message-ID: <1273268637.3542.130.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 14:35 -0700, Arve Hjønnevåg wrote:
> On Fri, May 7, 2010 at 2:30 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> > On Fri, 2010-05-07 at 22:03 +0100, Matthew Garrett wrote:
> >
> >> Here's a different example. A process is waiting for a keypress, but
> >> because it's badly written it's also drawing to the screen at 60 frames
> >> per second and preventing the system from every going to idle. How do
> >> you quiesce the system while still ensuring that the keypress will be
> >> delivered to the application?
> >
> > To me it's somewhat of a negative for suspend blockers. Since to solve
> > the problem you give above you would have to use a suspend blocker in an
> > asynchronous way (locked in an interrupt, released in a thread too)
> > assuming I understand your example. I've had my share of semaphore
> > nightmares, and I'm not too excited to see a protection scheme (i.e. a
> > lock) which allows asynchronous usage like suspend blockers.
> >
> 
> Why do you think this? The example in the documentation describe how
> we handle key events.

+- The Keypad driver gets an interrupt. It then calls suspend_block on the
+  keypad-scan suspend_blocker and starts scanning the keypad matrix.
+- The keypad-scan code detects a key change and reports it to the input-event
+  driver.
+- The input-event driver sees the key change, enqueues an event, and calls
+  suspend_block on the input-event-queue suspend_blocker.
+- The keypad-scan code detects that no keys are held and calls suspend_unblock
+  on the keypad-scan suspend_blocker.
+- The user-space input-event thread returns from select/poll, calls
+  suspend_block on the process-input-events suspend_blocker and then calls read
+  on the input-event device.
+- The input-event driver dequeues the key-event and, since the queue is now
+  empty, it calls suspend_unblock on the input-event-queue suspend_blocker.
+- The user-space input-event thread returns from read. If it determines that
+  the key should leave the screen off, it calls suspend_unblock on the
+  process_input_events suspend_blocker and then calls select or poll. The
+  system will automatically suspend again, since now no suspend blockers are
+  active.

This? Isn't this asynchronous on the input-event-queue since it's taken
in the interrupt , and release in the userspace thread?

Daniel

