Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737Ab0FCDKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 23:10:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58213 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab0FCDKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 23:10:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=PkwLsL9i+XzlM5V8jAaO9G5FyXwupx7SLQLi2tMGqN4kWXyyXsd4sOBJBJ2DaW/SS0
         P3L0aWtansXLyk50HKOwKh2nbrJumcPlUEYoPzIcwmBSUolWF09wrw92NuKuY0MGLNpI
         jKtbQBBoCmShO1BNT5aDj/SCOGACXQ7/CG83Q=
Date: Wed, 2 Jun 2010 20:10:24 -0700
From: mark gross <640e9920@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: markgross@thegnar.org,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>, 640e9920@gmail.com,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100603031024.GA11311@gvim.org>
Reply-To: markgross@thegnar.org
References: <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com>
 <AANLkTikF-B23_UWG1O3tlBl4m8NStAJllGhhevNhYZT6@mail.gmail.com>
 <20100602133910.GA9106@gvim.org>
 <201006030003.49486.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201006030003.49486.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 12:03:49AM +0200, Rafael J. Wysocki wrote:
> On Wednesday 02 June 2010, mark gross wrote:
> > On Tue, Jun 01, 2010 at 08:50:02PM -0700, Arve Hjønnevåg wrote:
> > > On Tue, Jun 1, 2010 at 7:05 AM, mark gross <640e9920@gmail.com> wrote:
> > > > On Tue, Jun 01, 2010 at 09:07:37AM +0200, Florian Mickler wrote:
> > > ...
> > > >> +static void update_target_val(int pm_qos_class, s32 val)
> > > >> +{
> > > >> +     s32 extreme_value;
> > > >> +     s32 new_value;
> > > >> +     extreme_value = atomic_read(&pm_qos_array[pm_qos_class]->target_value);
> > > >> +     new_value = pm_qos_array[pm_qos_class]->comparitor(val,extreme_value);
> > > >> +     if (extreme_value != new_value)
> > > >> +             atomic_set(&pm_qos_array[pm_qos_class]->target_value,new_value);
> > > >> +}
> > > >> +
> > > >
> > > > Only works 1/2 the time, but I like the idea!
> > > > It fails to get the righ answer when constraints are reduced.  But, this
> > > > idea is a good improvement i'll roll into the next pm_qos update!
> > > >
> > > 
> > > I think it would be a better idea to track your constraints with a
> > > sorted data structure. That way you can to better than O(n) for both
> > > directions. If you have a lot of constraints with the same value, it
> > > may even be worthwhile to have a two stage structure where for
> > > instance you use a rbtree for the unique values and list for identical
> > > constraints.
> > 
> > I don't agree, we went through this tree vrs list discussion a few times
> > before in other areas of the kernel.  Wherever the list tended to be
> > short, a simple list wins.  However; we can try it, after we have some
> > metrics and stress test cases identified we can measure its effectivenes
> > against.
> 
> How many different values are there to handle?
>

for the current pm_qos users its tiny.  I've never heard of more than a
few < 10.  However; for the new "interactive" class to provide suspend
blocker functionality, I expect the number to be up to 20.

but realistically I bet we never get more than 10ish.

One constraint constraint request per module from isr to user mode.
Once in user mode there would be only a few (assuming Android user
space) I think just from the power HAL, input HAL, and the RIL.

Still a pretty small number I don't think we need to worry about scaling
as much as we need to worry about performance.

--mgross 
