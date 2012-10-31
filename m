Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965246Ab2JaBGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 21:06:51 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58194 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab2JaBGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 21:06:49 -0400
MIME-Version: 1.0
In-Reply-To: <23121.1351645166@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
	<20121030192148.11000.3582.stgit@warthog.procyon.org.uk>
	<CAGXu5jK22D_15jYopqaegYAGSHO2x0asXogXCnZGfMw2KwUVNw@mail.gmail.com>
	<23121.1351645166@warthog.procyon.org.uk>
Date: Tue, 30 Oct 2012 18:06:48 -0700
X-Google-Sender-Auth: byTvu7WfQWebgLMt6eu-fs8j-zw
Message-ID: <CAGXu5jLjffRB6FcgPvg=gvsOk8cX-+nMgzFGmndm_PLMxdWk=Q@mail.gmail.com>
Subject: Re: [PATCH 16/23] pefile: Parse a PE binary to find a key and a
 signature contained therein
From: Kees Cook <keescook@chromium.org>
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, pjones@redhat.com, jwboyer@redhat.com,
        mjg@redhat.com, dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 5:59 PM, David Howells <dhowells@redhat.com> wrote:
> Kees Cook <keescook@chromium.org> wrote:
>
>> This multiplication can push the cursor out of bounds. (n_data_dirents
>> is unverified).
>> ...
>> Both of these cases of n_sections multiplications can wrap.
>> Ultimately, you can end up with cursor close to zero, but n_sections
>> being giant.
>
> Good points.  I wonder if I should limit these to some low number, or just
> check that they don't exceed header_size, which also needs checking as you
> said.

I think header_size can be bounded by datalen? I didn't investigate
that one very deeply. For the multiplications, I think you can just do
a check before chkaddr:

ctx->n_sections = pe->sections;
if (datalen / ctx->n_sections > sizeof(*sec))
    return -ELIBBAD;
chkaddr(0, cursor, sizeof(*sec) * ctx->n_sections);

Or extend chkaddr to do the check for you:

chkaddr(0, cursor, sizeof(*sec), ctx->n_sections);

with other callers just using "1" for the final argument.

Either way, you won't have to choose arbitrary limits.

-Kees

-- 
Kees Cook
Chrome OS Security
