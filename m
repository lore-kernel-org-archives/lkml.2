Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab1AND3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:29:21 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50887 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab1AND3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:29:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=so3AAd0mxtLoBKIwmWNX4plDPYxZ1SM+N84dy2ONw1E60c/g3irMMqaotC0KeIy8yw
         QMZ6WM82Y3C3oHtZbnvvBA/5D98jpSIkyecM/KB24P1d0PkCfs4iXAa01mNJMSEJfkkA
         ZSqqre9m8zSLlBsRFknRyykq9Mn1JMBYeUWOs=
MIME-Version: 1.0
In-Reply-To: <20110114032052.GV19804@ZenIV.linux.org.uk>
References: <8855.1294927436@jrobl>
	<AANLkTik1bj=Z9xFv8JfYrxqefFL1owmH=Rctj=XnH4Mp@mail.gmail.com>
	<20110114030325.GU19804@ZenIV.linux.org.uk>
	<AANLkTi=H7Zhe4VMsh_tdrd7Atb9FX8j4AdiMNepXGsj9@mail.gmail.com>
	<20110114032052.GV19804@ZenIV.linux.org.uk>
Date: Fri, 14 Jan 2011 14:29:11 +1100
Message-ID: <AANLkTi=NJE-rXgFZ44BU4U2KrDg0657ucpupT+RGC4sj@mail.gmail.com>
Subject: Re: vfs-scale, d_revalidate from nfsd
From: Nick Piggin <npiggin@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 2:20 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Jan 14, 2011 at 02:12:35PM +1100, Nick Piggin wrote:
>> The main idea here would be to just pass in a flags parameter rather
>> thank poking in nd to get the rcu-walk status. That would solve this
>> problem and also avoid nd for most filesystems that don't care about
>> it.
>
> Start with nd->flags getting passed explicitly, and be ready to see
>        * call on the final stage of open split away and folded with
> ->lookup() and ->open()/->creat()
>        * the rest of callers to lose nd completely.
> That's what's going to happen in the next cycle.

OK that sounds nice. I'll see what it looks like and definitely run any
proposed API change past you and fsdevel.


> BTW, why on the earth do you have that:
> static int xattr_hide_revalidate(struct dentry *dentry, struct nameidata *nd)
> {
>        if (nd->flags & LOOKUP_RCU)
>                return -ECHILD;
>        return -EPERM;
> }
> when the sole intent of that sucker is to have dentry of /.xattr (pinned
> in dcache and hashed all along) rejected on lookups from root?  IOW, WTF
> bother with -ECHILD here at all?

That's true. I guess I always have a weakness for doing "just one
little easy optimisation/simplification" folded into patch that is supposed
to be more mechanical changes :) I did have exactly that in the patch
initially, but I decided it's better just to do everything with -ECHILD first.

That also gives the -ECHILD paths a bit more workout before
fs conversions are done, too.
