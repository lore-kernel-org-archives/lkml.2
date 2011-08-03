Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab1HCHub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 03:50:31 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39374 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1HCHu1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 03:50:27 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFx_FMg2Y0jMrzYUpAqgxWFjxnFzzrqvysoqrYyz+Ue6BQ@mail.gmail.com>
References: <20110801180151.GA26686@albatros>
	<20110801112021.25ec9041.akpm@linux-foundation.org>
	<20110801190341.GA6898@albatros>
	<CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
	<20110802124530.GA2543@albatros>
	<CA+55aFx_FMg2Y0jMrzYUpAqgxWFjxnFzzrqvysoqrYyz+Ue6BQ@mail.gmail.com>
Date: Wed, 3 Aug 2011 09:50:26 +0200
Message-ID: <CAOLZvyEiOasozPb8ZBpNjcoUjOsrR+cGhc0hJxz8KAdNgNdHOA@mail.gmail.com>
Subject: Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Marc Zyngier <maz@misterjones.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        kernel-hardening@lists.openwall.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 3, 2011 at 9:43 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Aug 2, 2011 at 2:45 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>>
>> From: Vasiliy Kulikov <segoon@openwall.com>
>> Subject: [PATCH] shm: fix a race between shm_exit() and shm_init()
>
> This patch is disgusting.
>
> Doing things like this:
>
>> +       /*
>> +        * For init_ipc_ns shm_ids().rw_mutex is statically initialized
>> +        * as kernel threads should be able to use it in do_exit() before
>> +        * shm_init(), which is called on do_initcall()
>> +        */
>> +       if (ns == &init_ipc_ns)
>> +               __ipc_init_ids(&shm_ids(ns));
>> +       else
>> +               ipc_init_ids(&shm_ids(ns));
>
> should have told you that there is something totally wrong with your patch.
>
> I'd prefer to really do the initialization in the allocator (at which
> point it would be very natural to do the initialization statically for
> a static allocation, and you wouldn't have the above kind of nasty
> conditional stuff), but that whole namespace initialization and setup
> just looks pretty nasty.
>
> Looking at some of the other cases like net_ns_init(), maybe the
> proper fix is to just make 'ipc_ns_init()' be a pure_initcall().
>
> Does the attached patch work?

No, same oops still.

Manuel
