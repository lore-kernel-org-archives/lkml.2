Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1BVRVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:21:05 -0500
Received: from www.tglx.de ([62.245.132.106]:48174 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab1BVRVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:21:03 -0500
Date: Tue, 22 Feb 2011 18:20:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] debugobjects: print more data
In-Reply-To: <20110222121914.GA27963@redhat.com>
Message-ID: <alpine.LFD.2.00.1102221627520.2701@localhost6.localdomain6>
References: <20110222121914.GA27963@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011, Stanislaw Gruszka wrote:
> On main print function I changed WARN to printk to avoid "cut off" lines
> and keep all informations together.

Sorry for not noticing the problem with this earlier. It makes bug
reporting for Joe user harder than it is now. The WARN based output is
automatically captured by kerneloops and other tools. Your change
prevents it.

And we can be more clever about it.

>  struct debug_obj_descr {
>  	const char		*name;
> -
> +	void (*print)		(void *addr);

So we could change that function to be

        void *(debug_hint)	(void *addr);

And let it do:

static void *debug_hint(void *addr)
{
	return ((struct hrtimer *) addr)->function;
}

The object pointer itself is already known and pretty pointless. There
is really no debug value in the pointer itself.

That would change debug_print_object() to:

     void *hint = descr->debug_hint ? descr->debug_hint(obj->object) : NULL;

and make

    WARN(1, KERN_ERR "ODEBUG: %s %s (active state %u) object type: %s hint: %pS\n",
  			msg, obj_states[obj->state], obj->astate,
  			obj->descr->name, hint);

So we get the valuable additional information w/o losing the ability
of automated bug reports. And I think all we ever want is something
like a callback function, which helps us to identify the object.

Thanks,

	tglx
