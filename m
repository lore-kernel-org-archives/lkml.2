Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab2HTLAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:00:53 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:33196 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab2HTLAt convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Mon, 20 Aug 2012 07:00:49 -0400
Message-Id: <503234FC0200007800096611@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 20 Aug 2012 12:00:44 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: <x86@kernel.org>, <akpm@linux-foundation.org>, <ak@linux.intel.com>,
        <mmarek@suse.cz>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 55/74] lto, workaround: Add workaround for initcall
 reordering
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
 <1345345030-22211-56-git-send-email-andi@firstfloor.org>
 <5030B5DC020000780008A226@nat28.tlf.novell.com>
 <20120819150140.GP11413@one.firstfloor.org>
In-Reply-To: <20120819150140.GP11413@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.08.12 at 17:01, Andi Kleen <andi@firstfloor.org> wrote:
> On Sun, Aug 19, 2012 at 09:46:04AM +0100, Jan Beulich wrote:
>> >>> Andi Kleen <andi@firstfloor.org> 08/19/12 5:05 AM >>>
>> >Work around a LTO gcc problem: when there is no reference to a variable
>> >in a module it will be moved to the end of the program. This causes
>> >reordering of initcalls which the kernel does not like.
>> >Add a dummy reference function to avoid this. The function is
>> >deleted by the linker.
>> 
>> This is not even true on x86, not to speak of generally.
> 
> Why is it not true ? 
> 
> __initcall is only defined for !MODULE and there __exit discards.

__exit, on x86 and perhaps other arches, causes the code
to be discarded at runtime only.

>> >+#ifdef CONFIG_LTO
>> >+/* Work around a LTO gcc problem: when there is no reference to a variable
>> >+ * in a module it will be moved to the end of the program. This causes
>> >+ * reordering of initcalls which the kernel does not like.
>> >+ * Add a dummy reference function to avoid this. The function is 
>> >+ * deleted by the linker.
>> >+ */
>> >+#define LTO_REFERENCE_INITCALL(x) \
>> >+    ; /* yes this is needed */            \
>> >+    static __used __exit void *reference_##x(void)     \
>> 
>> Why not put it into e.g. section .discard.text? That could be expected to be
>> discarded by the linker without being arch dependent, as long as all arches
>> use DISCARDS in their linker script.
> 
> 
> That's what __exit does, doesn't it?

No - see above. Using .discard.* enforces the discarding at link
time.

Jan

