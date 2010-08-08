Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab0HHUHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 16:07:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40024 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab0HHUHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 16:07:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KlHGxD3kk617xYGrdgl/LwheDdD2IDwuonhSbPaJYXM4gxWQe2JEfd512Qkm+/oV9K
         3KGXG4bpvq1rMy2TdNRKJsNHLxIApcPl7q4n8rYuAxCN8pd8ZAMXBmM2bY/K3h6jnCum
         uOVxKqGGKtizPE1l8J+iRGNyZG9TDhNWIPh3k=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=F5andv+K1XRdVrFL6gL22CC++fGJJJ3d3nFyb@mail.gmail.com>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
	<1281261789.2384.11.camel@localhost>
	<AANLkTi=F5andv+K1XRdVrFL6gL22CC++fGJJJ3d3nFyb@mail.gmail.com>
Date: Sun, 8 Aug 2010 13:07:49 -0700
Message-ID: <AANLkTikEN_RBQeOTKxjLp2sud1qyCjFtWSXVXXMc79zw@mail.gmail.com>
Subject: Re: [PATCH 0/6] improve list_sort test
From: Don Mullis <don.mullis@gmail.com>
To: dedekind1@gmail.com
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 8, 2010 at 12:31 PM, Don Mullis <don.mullis@gmail.com> wrote:
> Artem Bityutskiy <dedekind1@gmail.com> writes:
>> Actually, your 'list_sort()' version does have a problem. I found out
>> that it calls 'cmp(priv, a, b)' with 'a = b' sometimes, and in these
>> cases 'a' and 'b' can point to something which is not a valid element of
>> the original list. Probably a senitel or something like that.

Looks like if the original list is a POT in length, the first callback
from line 73 will pass a==b both pointing to the original list_head.
Would you be able to test this fix?

--- linux-2.6.orig/lib/list_sort.c
+++ linux-2.6/lib/list_sort.c
@@ -70,7 +70,7 @@ static void merge_and_restore_back_links
                 * element comparison is needed, so the client's cmp()
                 * routine can invoke cond_resched() periodically.
                 */
-               (*cmp)(priv, tail, tail);
+               (*cmp)(priv, tail->next, tail->next);

                tail->next->prev = tail;
                tail = tail->next;
