Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0EJV5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:57:16 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:58330 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab0EJV5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:57:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Yn6nJuuGFDADIqBXy56goYPJgjby0oPLTrXrbFgmfvp2YEuyHr8/SkMAp+gn3NHyeW
         ap4FaGdgmuyK6V/dtOA0L9zVQv5sPVyf5kZCjTlHQYMcRBxvrf++No5nwthZ3MS4XdeF
         ok8atY7aWytXN9fAuKxtAfjY7kFoNXU9cL9p4=
MIME-Version: 1.0
In-Reply-To: <1273525827.22438.4489.camel@gandalf.stny.rr.com>
References: <20100510152708.GS5104@lenovo>
	 <1273525827.22438.4489.camel@gandalf.stny.rr.com>
Date: Tue, 11 May 2010 01:57:14 +0400
Message-ID: <l2xaa79d98a1005101457n3526dafag13ea897000c8066b@mail.gmail.com>
Subject: Re: [rfc] x86,perf: P4 PMU -- use hash for p4_get_escr_idx
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
Cc: Lin Ming <ming.m.lin@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 11, 2010, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2010-05-10 at 19:27 +0400, Cyrill Gorcunov wrote:
>
>>  static int p4_get_escr_idx(unsigned int addr)
>>  {
>> -     unsigned int i;
>> +     unsigned int idx = P4_ESCR_MSR_IDX(addr);
>>
>> -     for (i = 0; i < ARRAY_SIZE(p4_escr_map); i++) {
>> -             if (addr == p4_escr_map[i])
>> -                     return i;
>> -     }
>> +     BUG_ON(idx >= P4_ESCR_MSR_TABLE_SIZE);
>> +     BUG_ON(!p4_escr_table[idx]);
>
> Is there any softer way to handle this. IOW, must it be a BUG_ON()? or
> can you add a WARN_ON() and pass back something that will cause it to
> fail a bit nicer.
>

yes, we could warn here and just drop such an event from scheduling.
Thanks Steven! Dont know why i didnt use it initially ;)

> A BUG_ON() may panic the box and if you are in X on a laptop, all you
> see is that your box locked up hard. If this is a WARN_ON() and you can
> prevent further damage to the computer (no file corruption or anything)
> then the user may notice, "Oh, my dmesg has this nasty error here", and
> report something useful.
>
> You could do:
>
>         if (WARN_ON(idx >= P4_ESCR_MSR_TABLE_SIZE))
>                 return -1;
>
> or whatever.
>
> Thanks,
>
> -- Steve
>
>>
>> -     return -1;
>> +     return idx;
>>  }
>>
>
>
