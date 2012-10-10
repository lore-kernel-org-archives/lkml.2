Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2JJJSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:18:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57875 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2JJJSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:18:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAJn8CcGF90a-fHfQmA8UoY-RxvTqs2F_iVZVernEk6TGmdMuGQ@mail.gmail.com>
References: <1349553393-902065-1-git-send-email-avagin@openvz.org>
	<20121009114821.dc4c2aff.akpm@linux-foundation.org>
	<20121009190300.GB22108@kroah.com>
	<20121009120831.8a6d81d8.akpm@linux-foundation.org>
	<20121010074923.GA11894@kroah.com>
	<CAJn8CcGF90a-fHfQmA8UoY-RxvTqs2F_iVZVernEk6TGmdMuGQ@mail.gmail.com>
Date: Wed, 10 Oct 2012 17:18:48 +0800
Message-ID: <CAJn8CcHL_F-pWW9eOcMDzJUfuZ7qibuEG4Wtm4+jW=xKvjad-g@mail.gmail.com>
Subject: Re: [PATCH] pidns: remove recursion from free_pid_ns (v3)
From: Xiaotian Feng <xtfeng@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 5:12 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
> On Wed, Oct 10, 2012 at 3:49 PM, Greg KH <greg@kroah.com> wrote:
>> On Tue, Oct 09, 2012 at 12:08:31PM -0700, Andrew Morton wrote:
>>> On Tue, 9 Oct 2012 12:03:00 -0700
>>> Greg KH <greg@kroah.com> wrote:
>>>
>>> > On Tue, Oct 09, 2012 at 11:48:21AM -0700, Andrew Morton wrote:
>>> > > On Sat,  6 Oct 2012 23:56:33 +0400
>>> > > Andrew Vagin <avagin@openvz.org> wrote:
>>> > >
>>> > > > Here is a stack trace of recursion:
>>> > > > free_pid_ns(parent)
>>> > > >   put_pid_ns(parent)
>>> > > >     kref_put(&ns->kref, free_pid_ns);
>>> > > >       free_pid_ns
>>> > > >
>>> > > > This patch turns recursion into loops.
>>> > > >
>>> > > > pidns can be nested many times, so in case of recursion
>>> > > > a simple user space program can provoke a kernel panic
>>> > > > due to exceed of a kernel stack.
>>> > >
>>> > > So we should backport this into earlier kernels.
>>> > >
>>> > > > --- a/include/linux/kref.h
>>> > > > +++ b/include/linux/kref.h
>>> > > > @@ -95,6 +95,18 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
>>> > > >         return kref_sub(kref, 1, release);
>>> > > >  }
>>> > > >
>>> > > > +/**
>>> > > > + * kref_put - decrement refcount for object.
>>> > > > + * @kref: object.
>>> > > > + *
>>> > > > + * Decrement the refcount.
>>> > > > + * Return 1 if refcount is zero.
>>> > > > + */
>>> > > > +static inline int __kref_put(struct kref *kref)
>>> > > > +{
>>> > > > +       return atomic_dec_and_test(&kref->refcount);
>>> > > > +}
>>> > >
>>> > > Greg might be interested in this.
>>> > >
>>> > > It's a pretty specialised thing and perhaps it needs some stern words
>>> > > in the description explaining when and why it should and shouldn't be
>>> > > used.
>>> > >
>>> > > I wonder if people might (ab)use this to avoid the "doesn't
>>> > > have a release function" warning.
>>> >
>>> > Yes they would, please don't do this at all.
>>> >
>>> > In fact, why is it needed?  It doesn't solve anything (if it does,
>>> > something in the way the kref is being used is wrong.)
>>> >
>>>
>>> It's right there in the changelog.  The patch fixes deep
>>> kref_put->release->kref_put recursion by turning the operation for
>>> pidns into a loop.
>>
>> But why would a kref release function ever decrement the same kref
>> again causing a loop in the first place?
>>
>
> This should be kref_put ns->parent recursionly,  put_pid_ns(ns) ->
> free_pid_ns(ns) -> put_pid_ns(ns->parent)->.......
> If users create many nested namespaces, the recursion put_pid_ns()
> will exausted the kernel stack.
>
>
>> That's what I was referring to.  This strongly sounds like a problem in
>> how the kref is being used, not in the kref code itself.
>>
>> Is a kref even the correct thing here?
>
> Can we fix this by this way? free_pid_ns just release ns itself, we check
> the return value of kref_put, if kref_put returns 1, means ns->kref is removed,
> then we kref_put(ns->parent).
>
> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
> index 00474b0..2168535 100644
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -53,8 +53,14 @@ extern int reboot_pid_ns(struct pid_namespace
> *pid_ns, int cmd);
>
>  static inline void put_pid_ns(struct pid_namespace *ns)
>  {
> -       if (ns != &init_pid_ns)
> -               kref_put(&ns->kref, free_pid_ns);
> +       int ret;
> +      struct pid_namespace *parent

miss a ";" here

> +
> +       while (ns != &init_pid_ns) {
> +              parent = ns->parent;
> +               ret = kref_put(&ns->kref, free_pid_ns);
> +               if (!ret)

This line should be "if (!ret | !parent)"

> +                       break;
> +               else ns = parent;
> +       }
>  }
>
>  #else /* !CONFIG_PID_NS */
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 478bad2..85ca23a 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -135,15 +135,11 @@ struct pid_namespace *copy_pid_ns(unsigned long
> flags, struct pid_namespace *old
>
>  void free_pid_ns(struct kref *kref)
>  {
> -       struct pid_namespace *ns, *parent;
> +       struct pid_namespace *ns;
>
>         ns = container_of(kref, struct pid_namespace, kref);
>
> -       parent = ns->parent;
>         destroy_pid_namespace(ns);
> -
> -       if (parent != NULL)
> -               put_pid_ns(parent);
>  }
>  EXPORT_SYMBOL_GPL(free_pid_ns);
>
>
>>
>> greg k-h
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
