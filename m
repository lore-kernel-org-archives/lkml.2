Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab0EFGa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:30:27 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36007 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694Ab0EFGaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:30:25 -0400
X-Sasl-enc: cq9VLwe25Uoh0OkBj6QoOKpJIryGlDzCnn/q9Ie9To9w 1273127423
Message-ID: <4BE261FE.60109@ladisch.de>
Date: Thu, 06 May 2010 08:30:22 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: "dhprince.devel@yahoo" <dhprince.devel@yahoo.co.uk>
CC: linux-input@vger.kernel.org, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 2.6.34-rc5] HID: Prodikeys PC-MIDI HID Driver
References: <4BE1A2E2.1040801@yahoo.co.uk>
In-Reply-To: <4BE1A2E2.1040801@yahoo.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dhprince.devel@yahoo wrote:
> A specialised HID driver for the CreativeLabs Prodikeys PC-MIDI USB 
> Keyboard.
> ...

I cannot comment on the input stuff, but the sound stuff looks good
overall.

> +What:        /sys/bus/hid/drivers/prodikeys/.../channel
> +Date:        April 2010
> +KernelVersion:    2.6.34
> +Contact:    Don Prince <dhprince.devel@yahoo.co.uk>
> +Descripts/checkpatch.plscription:

Huh?

> +What:        /sys/bus/hid/drivers/prodikeys/.../sustain
> +Description:
> +        Allows control (via software) the sustain duration of a
> +        note held by the pc-midi driver.

Why is this feature needed?  Does the device report key releases
incorrectly?

These three sysfs controls could also be implemented as mixer controls.
This would allow them to be automatically saved and restored when the
computer is shut down.

> +    { HID_USB_DEVICE(USB_VENDOR_ID_CREATIVELABS, 
> USB_DEVICE_ID_PRODIKEYS_PCMIDI) },

Your mailer wrapped long lines and killed the tabs.
Please see <Documentation/email-clients.txt>.

And your code looks as if it does not use eight-column tabs for
indention.

> +static void pcmidi_send_note(struct pcmidi_snd *pm,
> ...
> +    res = snd_rawmidi_receive(pm->in_substream, buffer, 3);

This return value is never used.

> +                    if (!atomic_read(&pms->in_use)) {
> +                        pms->status = status;
> +                        pms->note = note;
> +                        pms->velocity = velocity;
> +                        atomic_set(&pms->in_use, 1);

If you're using the atomic variable to protect against some concurrently
executing code, then you have a race condition in the time interval
between the read and the set.

> +static void pcmidi_out_tasklet(unsigned long data)
> ...
> +    while (1) {
> +        /* just read them and drop them */
> +        u8 b;
> +        if (snd_rawmidi_transmit(pm->out_substream, &b, 1) != 1) {
> +            pm->out_active = 0;
> +            break;
> +        }

This isn't quite how output ports are supposed to be implemented.  :-)

I'd guess you want to remove the OUTPUT and DUPLEX flags and to drop all
output-related functions.

> +static void pcmidi_in_trigger(struct snd_rawmidi_substream *substream, 
> int up)
> ...
> +    if (up)
> +        set_bit(substream->number, &pm->in_triggered);
> +    else
> +        clear_bit(substream->number, &pm->in_triggered);

You have only one substream, a boolean variable would suffice.

> +int pcmidi_snd_initialise(struct pcmidi_snd *pm)
> ...
> +    int out_ports = 1;
> +    int in_ports = 1;

These variables are not variable and therefore not needed.

> +    snd_component_add(card, "MIDI");

This function is intended for sound cards that are composed of several
components, and the component name is usually a chip name.  I think
you don't need to call this function at all.

> +    err = snd_card_register(card);
> ...
> +    /* create sysfs variables */
> +    err = device_create_file(&pm->pk->hdev->dev,
> +                 sysfs_device_attr_channel);
> ...
> +    spin_lock_init(&pm->rawmidi_in_lock);
> +
> +    init_sustain_timers(pm);

snd_card_register() makes all sound interfaces available to userspace.
Initializations for any data that might be accessed from userspace must
be done before that call.


Regards,
Clemens
