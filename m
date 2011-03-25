Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1CYOFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:05:24 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56577 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab1CYOFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xnVB21vIwaTyTEM9Wu71IL8o3agwXqK5qYNP2JOER0O2GXqgCsRF2LcZsqNpcs49WD
         20jt74yhVacVFGBQ/vOyh/NrVkpCuamZbh1hGXUJM/eMZY1VkLqQo4uqThxMZseFmPno
         5yGVYtfdZ/TbVG6LtwE4BYVPbS7wdGSHr7Z6U=
MIME-Version: 1.0
In-Reply-To: <20110325135311.GA14328@thinkpad-t410>
References: <20110324195720.GB31713@thinkpad-t410>
	<1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
	<AANLkTimF2UR8BVQW-3YJaGFEz39q8ydESAiMOjmdM1X7@mail.gmail.com>
	<20110325135311.GA14328@thinkpad-t410>
Date: Fri, 25 Mar 2011 14:05:18 +0000
Message-ID: <AANLkTin3MDYdL6x1Qs8Q9oMMgDMfsoO2GjWMJO_65GAR@mail.gmail.com>
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate key
From: Corentin Chary <corentin.chary@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 1:53 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> On Fri, Mar 25, 2011 at 01:28:30PM +0000, Corentin Chary wrote:
>> > +static void eeepc_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int *code,
>> > +                                int *value, int *autorelease)
>> > +{
>> > +       struct eeepc_wmi_driver *eeepc = to_eeepc_wmi_driver(asus_wmi);
>> > +       int is_press;
>> > +
>> > +       /*
>> > +        * The following behavior is used for T101MT "Home" key:
>> > +        *
>> > +        *   On press:   No event set
>> > +        *   On hold:    KEY_PROG2 press sent once w/o autorelease
>> > +        *   On release: If key was held, KEY_PROG2 release sent.
>> > +        *               Otherwise KEY_HOME press sent w/ autorelease.
>> > +        *
>> > +        * The simple state machine below implements this behavior.
>> > +        */
>> > +       switch (*code) {
>> > +       case HOME_PRESS:
>> > +               eeepc->home_key_state = HOME_PRESS;
>> > +               *code = ASUS_WMI_KEY_IGNORE;
>> > +               break;
>> > +       case HOME_HOLD:
>> > +               if (eeepc->home_key_state == HOME_HOLD) {
>> > +                       *code = ASUS_WMI_KEY_IGNORE;
>> > +               } else {
>> > +                       eeepc->home_key_state = HOME_HOLD;
>> > +                       *value = 1;
>> > +                       *autorelease = 0;
>> > +               }
>> > +               break;
>> > +       case HOME_RELEASE:
>> > +               if (eeepc->home_key_state == HOME_RELEASE) {
>> > +                       dev_warn(&asus_wmi->platform_device->dev,
>> > +                                "Unexpected home key release event\n");
>> > +                       *code = ASUS_WMI_KEY_IGNORE;
>> > +               } else {
>> > +                       *code = eeepc->home_key_state;
>> > +                       eeepc->home_key_state = HOME_RELEASE;
>> > +                       is_press = (*code == HOME_PRESS);
>> > +                       *value = is_press;
>> > +                       *autorelease = is_press;
>> > +               }
>> > +               break;
>> > +       }
>> > +}
>> > +
>>
>> Why not something simpler like this ?
>>
>> static void eeepc_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int code,
>>                                                  int *value, int *autorelease)
>> {
>>         if (code == 0xe4) {
>>                 *value = 1;
>>                 *autorelease = 0;
>>         } else if (code == 0xe5) {
>>                 *value = 0;
>>                 *autorelease = 0;
>>        }
>> }
>>
>> with this keymap :
>>
>>        { KE_KEY, 0xe4, { KEY_HOME } }, /* Home Key Down */
>>        { KE_KEY, 0xe5, { KEY_HOME } }, /* Home Key Up */
>>        { KE_KEY, 0xea, { KEY_PROG2 } }, /* Home Key hold more than one second */
>>
>>
>> This sounds simpler and we don't loose information (key down and key
>> up both event reported at the right time).
>> 0xe5 is *always* sent after 0xe4 right ?
>
> I guess it depends on what key events we want on a press-and-hold.
> Remember that you're going to get a scan code sequence like "0xe4 0xea
> 0xea ... 0xea 0xe5", so with my implementation you get
>
>  KEY_PROG2 press
>  KEY_PROG2 release
>
> With yours
>
>  KEY_HOME press
>  KEY_PROG2 press
>  KEY_PROG2 release
>  // KEY_PROG2 press/release repeats every 0.5 secs while button held
>  KEY_HOME release
>
> At minimum I'd think we'd want to only send a single PROG2 press/release
> for button hold. My thought was that you'd only want to get the code for
> 0xe4 or 0xea, not both, but I suppose that's debatable.

If you keep a keyboard key pressed, you want multiple events, not one right ?
I think it's important not to loose informations. If someone keep this
key pressed more than 1.5 second, I think it's good idea to send
multiple KEY_PROG2.

About KEY_HOME press / release, and filtering KEY_HOME after
KEY_PROG2, I'm not sure. So if you really want it, and nobody
complains, I'll be happy to accept your patch.

> And back to the question of KEY_HOME -- that's not really what you want,
> is it? As in "move cursor to start of line"?

Ho .. right, that's what mean KEY_HOME :/. So no, I don't want that...
What about:
- KEY_CYCLEWINDOWS
- KEY_COMPUTER
- KEY_HOMEPAGE
- KEY_DASHBOARD

I think KEY_HOMEPAGE is the best choice.

-- 
Corentin Chary
http://xf.iksaif.net
