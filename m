Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab0C2Q6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:58:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57264 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab0C2Q6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:58:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WpRtzBX6L66rDAnaRywruxOz5IS7B1jGjqecqLlF1/Z3LpV8vIsH3w7106siKdwbWZ
         0zkHK4axoW80Pvsnvq7E3eSZXHZSFH2mvEOFbjgFwqr5NnVzfcSEaLIqQF9WagkYfSoY
         /q+/+qyv70CYMDRvpF8NStsJBvONa3plI1yr0=
MIME-Version: 1.0
In-Reply-To: <201003291942.56706.rusty@rustcorp.com.au>
References: <20100318105533.GE25636@laptop>
	 <201003291942.56706.rusty@rustcorp.com.au>
Date: Tue, 30 Mar 2010 03:58:49 +1100
Message-ID: <e619185d1003290958w23037176uc869c7dbc0a48bcc@mail.gmail.com>
Subject: Re: Is module refcounting racy?
From: Nick Piggin <npiggin@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 8:12 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Thu, 18 Mar 2010 09:25:34 pm Nick Piggin wrote:
>> Hey,
>>
>> I've been looking at weird and wonderful ways to do scalable refcounting,
>> for the vfs...
>>
>> Sadly, module refcounting doesn't fit my bill. But as far as I could see,
>> it is racy.
>
> Other than for advisory purposes, the refcount is only checked against zero
> under stop_machine.  For exactly this reason.

There definitely looks to me like there is code that checks the refcount
*without* stop_machine. module_refcount is an exported function, and you
expect drivers to get this right (scsi_device_put for a trivial example), but
it even looks like it is used in a racy way in kernel/module.c code.

Either we need to take my patch, or audit t, and put a WARN_ON
if it is called while not under stop_machine.
