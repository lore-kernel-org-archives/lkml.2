Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab1ANBVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:21:53 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60776 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab1ANBVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:21:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JBHahuvjTllDWP9sqsbEJmijuLtVOZ9L+ZNLO4mqbzXBpW1F4/xRkw9Xvwk+zTZDyp
         C+Z6L04Q+xoU2FcXK/n39xjxV1oC/d7EZAFwqxDDaRAFvPJErY3TztUw1iV8frXiQXlg
         zIpHW80+jK0yIlnCNIWE3rxfo0+QYuBkNH54g=
MIME-Version: 1.0
In-Reply-To: <E1PdPsR-0004BY-Q3@pomaz-ex.szeredi.hu>
References: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
	<E1PdOdT-00042k-RM@pomaz-ex.szeredi.hu>
	<E1PdPsR-0004BY-Q3@pomaz-ex.szeredi.hu>
Date: Fri, 14 Jan 2011 12:21:45 +1100
Message-ID: <AANLkTi=4mCaZzGXja0Z_VBS+fst8k8_=t1A-eZwfvKiA@mail.gmail.com>
Subject: Re: Important for fs devs: rcu-walk merged upstream
From: Nick Piggin <npiggin@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 3:18 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, 13 Jan 2011, Miklos Szeredi wrote:
>> On Sat, 8 Jan 2011, Nick Piggin wrote:
>> > The vfs-scale branch is now upstream. If you haven't
>> > looked yet, your filesystem is likely to have been
>> > touched, so check it out.
>> >
>> > Also look at Documentation/filesystems/porting and
>> > path-lookup.txt.
>> >
>> > The dcache_lock stuff should have been all done for you
>> > (for in-tree filesystems, I can help out of tree fses with
>> > conversions there if you ping me offline).
>> >
>> > The rcu-walk stuff can be more tricky for your filesystem
>> > to take advantage of.
>> >
>> > If you supply a .d_revalidate, .permission, or .check_acl,
>> > then path walking is going to be slow and unscalable for
>> > you.
>> >
>> > Out of tree filesystems: you _have_ to at least add a line
>> > of code to the above functions in order to specify that
>> > you don't want to participate in rcu-walk.
>> >
>> > Otherwise, you don't have to care about rcu-walk if you
>> > have a legacy or special filesystem like configfs then I'd
>> > advise against anything fancy. But if you have a
>> > userbase and you expect them to actually do any path
>> > lookups into your filesystem, please take a look.
>>
>> One other thing: I know ECHILD is safe since no sane filesystem will
>> return it in its permission or revalidate callbacks, and even if it
>> does that's just a loss of optimization.
>
> And it's not entirely safe either.  A fuse filesystem returning ECHILD
> would make nameidata_dentry_drop_rcu() to BUG.  So some sort of errno
> filter is necessary in the fuse kernel module.

Surely you'd need some filtering anyway? I don't think any function
involving path lookup could sanely return -ECHILD.

That said, it probably is a good idea to have a new errno.
