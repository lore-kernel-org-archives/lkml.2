Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2E2RWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:22:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab2E2RWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:22:38 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F5F26@ORSMSX104.amr.corp.intel.com>
References: <1336004953.4240.9.camel@mop> <20120526111143.GA32304@lizard>
 <CAPXgP10--rmzK8joBSrs3Abk7uuamJTDBbvrm6W6w_xODqZVtg@mail.gmail.com>
 <1338307620.886.21.camel@mop> <3908561D78D1C84285E8C5FCA982C28F192F5F26@ORSMSX104.amr.corp.intel.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 29 May 2012 19:22:17 +0200
Message-ID: <CAPXgP12wBzSoH-2PQeKxTbcDCKyjWdBVVz6scA7bpWxoSut7ew@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 7:11 PM, Luck, Tony <tony.luck@intel.com> wrote:
> +/*
> + * Fill the provided buffer with as many of the the *youngest* kmsg records
> + * that fit into it. Repeated calls will fill the buffer with the next block
> + * of older records, not including the former ones. A return value of FALSE
> + * indicate that all records are read, including the oldest one.
> + */
>
> I confess to not reading all of this ... but does this handle the pstore/OOPS
> case? We'll use this call to pull as many records as will fit in the pstore
> error record ... but almost certainly won't pull all of the console log, so
> we won't see the FALSE return.

The loop in pstore gets the newest messages first, then another chunk
of the older messages with every call; pstore stops to iterate when
the defined limit it wants to store is reached, or when no messages
are available anymore.

> The system keeps on running.
>
> Now another OOPS happens and pstore wants to grab the new "youngest" records,
> it doesn't want to continue stepping to older records from the place it got
> to on the first OOPS.  Will that work?

A new oops will init the iterator again, so it will start at the end
with the new messages that happened in the meantime.

The iterator is only valid while used from dump(), it will return an
error if used outside of it.

The logic *should* work; at least it should be easy to make it work if
it doesn't. :)

Kay
