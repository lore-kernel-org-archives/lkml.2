Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1CYNxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:53:22 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59845 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab1CYNxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:53:21 -0400
Date: Fri, 25 Mar 2011 08:53:11 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate
 key
Message-ID: <20110325135311.GA14328@thinkpad-t410>
Mail-Followup-To: Corentin Chary <corentin.chary@gmail.com>,
	Chris Bagwell <chris@cnpbagwell.com>,
	Matthew Garrett <mjg@redhat.com>,
	acpi4asus-user@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <20110324195720.GB31713@thinkpad-t410>
 <1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
 <AANLkTimF2UR8BVQW-3YJaGFEz39q8ydESAiMOjmdM1X7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimF2UR8BVQW-3YJaGFEz39q8ydESAiMOjmdM1X7@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 01:28:30PM +0000, Corentin Chary wrote:
> > +static void eeepc_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int *code,
> > +                                int *value, int *autorelease)
> > +{
> > +       struct eeepc_wmi_driver *eeepc = to_eeepc_wmi_driver(asus_wmi);
> > +       int is_press;
> > +
> > +       /*
> > +        * The following behavior is used for T101MT "Home" key:
> > +        *
> > +        *   On press:   No event set
> > +        *   On hold:    KEY_PROG2 press sent once w/o autorelease
> > +        *   On release: If key was held, KEY_PROG2 release sent.
> > +        *               Otherwise KEY_HOME press sent w/ autorelease.
> > +        *
> > +        * The simple state machine below implements this behavior.
> > +        */
> > +       switch (*code) {
> > +       case HOME_PRESS:
> > +               eeepc->home_key_state = HOME_PRESS;
> > +               *code = ASUS_WMI_KEY_IGNORE;
> > +               break;
> > +       case HOME_HOLD:
> > +               if (eeepc->home_key_state == HOME_HOLD) {
> > +                       *code = ASUS_WMI_KEY_IGNORE;
> > +               } else {
> > +                       eeepc->home_key_state = HOME_HOLD;
> > +                       *value = 1;
> > +                       *autorelease = 0;
> > +               }
> > +               break;
> > +       case HOME_RELEASE:
> > +               if (eeepc->home_key_state == HOME_RELEASE) {
> > +                       dev_warn(&asus_wmi->platform_device->dev,
> > +                                "Unexpected home key release event\n");
> > +                       *code = ASUS_WMI_KEY_IGNORE;
> > +               } else {
> > +                       *code = eeepc->home_key_state;
> > +                       eeepc->home_key_state = HOME_RELEASE;
> > +                       is_press = (*code == HOME_PRESS);
> > +                       *value = is_press;
> > +                       *autorelease = is_press;
> > +               }
> > +               break;
> > +       }
> > +}
> > +
> 
> Why not something simpler like this ?
> 
> static void eeepc_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int code,
>                                                  int *value, int *autorelease)
> {
>         if (code == 0xe4) {
>                 *value = 1;
>                 *autorelease = 0;
>         } else if (code == 0xe5) {
>                 *value = 0;
>                 *autorelease = 0;
>        }
> }
> 
> with this keymap :
> 
>        { KE_KEY, 0xe4, { KEY_HOME } }, /* Home Key Down */
>        { KE_KEY, 0xe5, { KEY_HOME } }, /* Home Key Up */
>        { KE_KEY, 0xea, { KEY_PROG2 } }, /* Home Key hold more than one second */
> 
> 
> This sounds simpler and we don't loose information (key down and key
> up both event reported at the right time).
> 0xe5 is *always* sent after 0xe4 right ?

I guess it depends on what key events we want on a press-and-hold.
Remember that you're going to get a scan code sequence like "0xe4 0xea
0xea ... 0xea 0xe5", so with my implementation you get

  KEY_PROG2 press
  KEY_PROG2 release

With yours

  KEY_HOME press
  KEY_PROG2 press
  KEY_PROG2 release
  // KEY_PROG2 press/release repeats every 0.5 secs while button held
  KEY_HOME release

At minimum I'd think we'd want to only send a single PROG2 press/release
for button hold. My thought was that you'd only want to get the code for
0xe4 or 0xea, not both, but I suppose that's debatable.

And back to the question of KEY_HOME -- that's not really what you want,
is it? As in "move cursor to start of line"?

> Also, for the callback, "value" should be an unsigned int, and
> "autorelease" a bool.

Right, silly mistake. Thanks for catching it.

