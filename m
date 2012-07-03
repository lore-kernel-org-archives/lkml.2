Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2GCKH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:07:26 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55960 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab2GCKHT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 3 Jul 2012 06:07:19 -0400
Message-Id: <4FF2E0AE020000780008D48E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 03 Jul 2012 11:08:14 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Glauber Costa" <glommer@parallels.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <jeremy@goop.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: __force_order usage on x86's CRn accesses
References: <4FF2D6AB020000780008D460@nat28.tlf.novell.com>
 <4FF2C19D.4040608@parallels.com>
In-Reply-To: <4FF2C19D.4040608@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.07.12 at 11:55, Glauber Costa <glommer@parallels.com> wrote:
>> Furthermore, the addition of these constraints happened
>> without any real explanation - the code comment that was added
>> doesn't really help understand why "volatile" isn't sufficient here.
> 
> If my memory dont't fail me, I believe this is because gcc will feel
> free to reorder a sequence of instructions that does not access memory.
> Specially since it has no knowledge of what's in the inline assembly,
> and what are its constraints. It only knows that it is an register
> operation, and treats it like one.
> 
> Also, I believe what we are concerned with here is not arbitrary reorder
> between that and other instructions, which we welcome, but reordering
> between a read and a write to the same crX - specially of concern for
> things doing read-modify-writes of control registers.

But such sequences can't be re-ordered when the asm-s are
volatile qualified.

>> Finally (and this is because I lack the explanation why the
>> artificial constraint is needed in the first place), why is it that
>> clts() doesn't need one too?
>> 
> 
> Because we're not using it to do read-modify-write of the control register.

Sequences of read_cr0()/clts()/write_cr0() certainly exist (in
the xor implementations), so if a read_cr0()/write_cr0() can
have issues (which is impossible if the value written depends on
the one read), read_cr0()/clts() would be even more affected,
as there's no compiler visible dependency between the two.

But I don't think any such can happen in reality, and I was
hoping to be provided with an example of proving me wrong
(and understand the whole situation).

Jan

