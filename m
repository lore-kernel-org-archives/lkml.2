Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab2HYTdi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 15:33:38 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:48522 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325Ab2HYTdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 15:33:01 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiNMAIonOVBV5qoUPGdsb2JhbABFhRqFI7AtGQEBAQEeGQ0ngiABAQQBJxMcEwEPBQsIAw4KFRkUJQoaE4gHCrtlFIp0g2mCSGADlVSFbI0P
X-IronPort-AV: E=Sophos;i="4.77,827,1336341600"; 
   d="scan'208";a="396850379"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 25 Aug 2012 21:38:10 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/19] Input: Send events one packet at a time
Message-ID: <20120825193810.GA4732@polaris.bitmath.org>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
 <1344807757-2217-7-git-send-email-rydberg@euromail.se>
 <CAGS+omC3x31Yq0c10AZzMtfaytUkhTRgkBnhekm=YdzAC5M8vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omC3x31Yq0c10AZzMtfaytUkhTRgkBnhekm=YdzAC5M8vA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> On Mon, Aug 13, 2012 at 5:42 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> > On heavy event loads, such as a multitouch driver, the irqsoff latency
> > can be as high as 250 us.  By accumulating a frame worth of data
> > before passing it on, the latency can be dramatically reduced.  As a
> > side effect, the special EV_SYN handling can be removed, since the
> > frame is now atomic.
> 
> This patch(set) is very interesting and exciting.  Thanks!
> Some questions and comments inline...
> 
> >
> > This patch adds the events() handler callback and uses it if it
> > exists. The latency is improved by 50 us even without the callback.
> 
> How much of the savings is just from reducing the number of
> add_input_randomness()  calls from 1-per-input_value to 1-per-frame?

Some, but the largest saving comes from calling down to evdev more sparsely.

> Could you achieve similar savings by only calling add_input_randomness
> on the first input_value after each EV_SYN/SYN_REPORT (ie "when sync =
> true")?

It might make a bit of a difference, because of the additional locks,
but I have not tried it explicitly.

> > @@ -90,46 +90,81 @@ static void input_stop_autorepeat(struct input_dev *dev)
> >   * filtered out, through all open handles. This function is called with
> >   * dev->event_lock held and interrupts disabled.
> >   */
> > -static void input_pass_event(struct input_dev *dev,
> > -                            unsigned int type, unsigned int code, int value)
> > +static size_t input_to_handler(struct input_handle *handle,
> > +                                   struct input_value *vals, size_t count)
> 
> The only thing that is a little strange with this function is that it
> actually changes the 'vals' array due to in-place filtering.

Hm, yes, I did not want to allocate additional memory for the
filtering stuff. It is only used in a few (one?) place, and TBH, it is
not on my list of favorite pieces of code. I would rather see that
api modified than working towards more elaborate filtering schemes.

> It means
> that input_to_handler can't handle const arrays of vals, which may
> have a performance impact in some cases (like key repeat).  You are
> relying on this behavior since you want to pass the final filtered
> input_value array to ->events() without copying, but this seems to be
> optimizing the 'filtered' case relative to the (normal?) unfiltered
> behavior.  Probably not worth changing, though.

Right.

> 
> >  {
> > -       struct input_handler *handler;
> > -       struct input_handle *handle;
> > +       struct input_handler *handler = handle->handler;
> > +       struct input_value *end = vals;
> > +       struct input_value *v;
> >
> > -       rcu_read_lock();
> > +       for (v = vals; v != vals + count; v++) {
> > +               if (handler->filter &&
> 
> if (handler->filter == false), you could skip the whole loop and just
> assign end = vals + count.

True - in principle, but currently a suboptimization.

> Also, the original version assumed that if a handler had the grab, it
> couldn't be a filter, and would skip filtering entirely.
> 
> > +                   handler->filter(handle, v->type, v->code, v->value))
> 
> Maybe we can have a handler->filter_events(handle, vals, count) that
> returns the number of events left after filtering.
> This would allow more sophisticated filtering that could inspect an
> entire frame.

Possibly. Still, the notion of filtering as information-sharing
between drivers on the input bus is not one of my favorites. IMHO,
focus should be on getting the data out of the kernel as quickly as
possible.

> 
> > +                       continue;
> > +               if (end != v)
> > +                       *end = *v;
> > +               end++;
> > +       }
> >
> > -       handle = rcu_dereference(dev->grab);
> > -       if (handle)
> > -               handle->handler->event(handle, type, code, value);
> > -       else {
> > -               bool filtered = false;
> > +       count = end - vals;
> > +       if (!count)
> > +               return 0;
> >
> > -               list_for_each_entry_rcu(handle, &dev->h_list, d_node) {
> > -                       if (!handle->open)
> > -                               continue;
> 
> In the original version, one handler would not call both ->filter()
> and ->event().
> I'm not sure if that was a bug or a feature.  But, you now make it possible.
> However, this opens up the possibility of a filter handler processing
> events via its ->event that would get filtered out by a later
> handler's filter.

True, but it does not change any of the existing usages of filtering.

> In sum, I think if we assume a handler only has either ->filter or
> ->event (->events), then we can split this function into two, one that
> only does filtering on filters, and one that only passes the resulting
> filtered events.
> 
> > +       if (handler->events)
> > +               handler->events(handle, vals, count);
> > +       else
> > +               for (v = vals; v != end; v++)
> > +                       handler->event(handle, v->type, v->code, v->value);
> > +
> > +       return count;
> > +}

My standpoint is clear by now, so I shall not repeat myself. :-)

> > @@ -326,14 +331,35 @@ static void input_handle_event(struct input_dev *dev,
> >                 break;
> >         }
> >
> > -       if (disposition != INPUT_IGNORE_EVENT && type != EV_SYN)
> > -               dev->sync = false;
> > +       return disposition;
> > +}
> > +
> > +static void input_handle_event(struct input_dev *dev,
> > +                              unsigned int type, unsigned int code, int value)
> > +{
> > +       struct input_value *v;
> > +       int disp;
> > +
> > +       disp = input_get_disposition(dev, type, code, value);
> >
> > -       if ((disposition & INPUT_PASS_TO_DEVICE) && dev->event)
> > +       if ((disp & INPUT_PASS_TO_DEVICE) && dev->event)
> >                 dev->event(dev, type, code, value);
> >
> > -       if (disposition & INPUT_PASS_TO_HANDLERS)
> > -               input_pass_event(dev, type, code, value);
> > +       if (!dev->vals)
> > +               return;
> > +
> > +       if (disp & INPUT_PASS_TO_HANDLERS) {
> > +               v = &dev->vals[dev->num_vals++];
> > +               v->type = type;
> > +               v->code = code;
> > +               v->value = value;
> > +       }
> > +
> > +       if ((disp & INPUT_FLUSH) || (dev->num_vals >= dev->max_vals)) {
> > +               if (dev->num_vals >= 2)
> 
> I'm not sure about this check.  What if the previous "frame" had
> dev->max_vals + 1 events, and so dev->max_vals of them (all but the
> SYN_REPORT) were already passed.
> We would not get that frame's SYN_REPORT all by itself, so "disp &
> INPUT_FLUSH" is true, but dev->num_vals == 1.  We still want to pass
> the SYN_REPORT immediately, and not save until we get another full
> frame.
> 
> Is this even possible?

Yes, it is possible, if the driver is misconfigured with respect to
the input buffer size. I have ignored that possibility in a few other
places as well (keyboard repeat for one). You are probably right in
that it should be handled somehow, but I would rather make sure the
buffer is always large enough. The atomicity of the frame is really
what makes things go faster.

> 
> > +                       input_pass_values(dev, dev->vals, dev->num_vals);
> > +               dev->num_vals = 0;
> > +       }
> >  }
> >
> >  /**
> > @@ -361,7 +387,6 @@ void input_event(struct input_dev *dev,
> >         if (is_event_supported(type, dev->evbit, EV_MAX)) {
> >
> >                 spin_lock_irqsave(&dev->event_lock, flags);
> > -               add_input_randomness(type, code, value);
> >                 input_handle_event(dev, type, code, value);
> >                 spin_unlock_irqrestore(&dev->event_lock, flags);
> >         }
> > @@ -842,8 +867,7 @@ int input_set_keycode(struct input_dev *dev,
> >             __test_and_clear_bit(old_keycode, dev->key)) {
> >
> >                 input_pass_event(dev, EV_KEY, old_keycode, 0);
> > -               if (dev->sync)
> > -                       input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
> > +               input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
> >         }
> >
> >   out:
> > @@ -1425,6 +1449,7 @@ static void input_dev_release(struct device *device)
> >         input_ff_destroy(dev);
> >         input_mt_destroy_slots(dev);
> >         kfree(dev->absinfo);
> > +       kfree(dev->vals);
> >         kfree(dev);
> >
> >         module_put(THIS_MODULE);
> > @@ -1845,6 +1870,14 @@ int input_register_device(struct input_dev *dev)
> >         if (dev->hint_events_per_packet < packet_size)
> >                 dev->hint_events_per_packet = packet_size;
> >
> > +       dev->num_vals = 0;
> > +       dev->max_vals = max(dev->hint_events_per_packet, packet_size);
> > +
> > +       kfree(dev->vals);
> How could this already be non-NULL?  Is it possible to re-register a device?

Uhm, you are probably right.

> A huge optimization to input event processing is pretty exciting!

Thanks for the review, I will send out a new patchset taking all the
response so far into account.
