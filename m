Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab1CYPNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:13:24 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51728 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1CYPNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:13:22 -0400
Date: Fri, 25 Mar 2011 10:13:10 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Chris Bagwell <chris@cnpbagwell.com>,
        Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate
 key
Message-ID: <20110325151310.GB14328@thinkpad-t410>
Mail-Followup-To: Chris Bagwell <chris@cnpbagwell.com>,
	Corentin Chary <corentin.chary@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	acpi4asus-user@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <20110324195720.GB31713@thinkpad-t410>
 <1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
 <AANLkTimF2UR8BVQW-3YJaGFEz39q8ydESAiMOjmdM1X7@mail.gmail.com>
 <20110325135311.GA14328@thinkpad-t410>
 <AANLkTin3MDYdL6x1Qs8Q9oMMgDMfsoO2GjWMJO_65GAR@mail.gmail.com>
 <AANLkTi=iWeKVww_XPm0PQa09NLtPCo4wvz7ZYkk1ajhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=iWeKVww_XPm0PQa09NLtPCo4wvz7ZYkk1ajhQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 09:53:20AM -0500, Chris Bagwell wrote:
> On Fri, Mar 25, 2011 at 9:05 AM, Corentin Chary
> <corentin.chary@gmail.com> wrote:
> > On Fri, Mar 25, 2011 at 1:53 PM, Seth Forshee
> > <seth.forshee@canonical.com> wrote:
> >> On Fri, Mar 25, 2011 at 01:28:30PM +0000, Corentin Chary wrote:
> >>> > +static void eeepc_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int *code,
> >>> > +                                int *value, int *autorelease)
> >>> > +{
> >>> > +       struct eeepc_wmi_driver *eeepc = to_eeepc_wmi_driver(asus_wmi);
> >>> > +       int is_press;
> >>> > +
> >>> > +       /*
> >>> > +        * The following behavior is used for T101MT "Home" key:
> >>> > +        *
> >>> > +        *   On press:   No event set
> >>> > +        *   On hold:    KEY_PROG2 press sent once w/o autorelease
> >>> > +        *   On release: If key was held, KEY_PROG2 release sent.
> >>> > +        *               Otherwise KEY_HOME press sent w/ autorelease.
> >>> > +        *
> >>> > +        * The simple state machine below implements this behavior.
> >>> > +        */
> >>> > +       switch (*code) {
> >>> > +       case HOME_PRESS:
> >>> > +               eeepc->home_key_state = HOME_PRESS;
> >>> > +               *code = ASUS_WMI_KEY_IGNORE;
> >>> > +               break;
> >>> > +       case HOME_HOLD:
> >>> > +               if (eeepc->home_key_state == HOME_HOLD) {
> >>> > +                       *code = ASUS_WMI_KEY_IGNORE;
> >>> > +               } else {
> >>> > +                       eeepc->home_key_state = HOME_HOLD;
> >>> > +                       *value = 1;
> >>> > +                       *autorelease = 0;
> >>> > +               }
> >>> > +               break;
> >>> > +       case HOME_RELEASE:
> >>> > +               if (eeepc->home_key_state == HOME_RELEASE) {
> >>> > +                       dev_warn(&asus_wmi->platform_device->dev,
> >>> > +                                "Unexpected home key release event\n");
> >>> > +                       *code = ASUS_WMI_KEY_IGNORE;
> >>> > +               } else {
> >>> > +                       *code = eeepc->home_key_state;
> >>> > +                       eeepc->home_key_state = HOME_RELEASE;
> >>> > +                       is_press = (*code == HOME_PRESS);
> >>> > +                       *value = is_press;
> >>> > +                       *autorelease = is_press;
> >>> > +               }
> >>> > +               break;
> >>> > +       }
> >>> > +}
> >>> > +
> >>>
> >>> Why not something simpler like this ?
> >>>
> >>> static void eeepc_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int code,
> >>>                                                  int *value, int *autorelease)
> >>> {
> >>>         if (code == 0xe4) {
> >>>                 *value = 1;
> >>>                 *autorelease = 0;
> >>>         } else if (code == 0xe5) {
> >>>                 *value = 0;
> >>>                 *autorelease = 0;
> >>>        }
> >>> }
> >>>
> >>> with this keymap :
> >>>
> >>>        { KE_KEY, 0xe4, { KEY_HOME } }, /* Home Key Down */
> >>>        { KE_KEY, 0xe5, { KEY_HOME } }, /* Home Key Up */
> >>>        { KE_KEY, 0xea, { KEY_PROG2 } }, /* Home Key hold more than one second */
> >>>
> >>>
> >>> This sounds simpler and we don't loose information (key down and key
> >>> up both event reported at the right time).
> >>> 0xe5 is *always* sent after 0xe4 right ?
> >>
> >> I guess it depends on what key events we want on a press-and-hold.
> >> Remember that you're going to get a scan code sequence like "0xe4 0xea
> >> 0xea ... 0xea 0xe5", so with my implementation you get
> >>
> >>  KEY_PROG2 press
> >>  KEY_PROG2 release
> >>
> >> With yours
> >>
> >>  KEY_HOME press
> >>  KEY_PROG2 press
> >>  KEY_PROG2 release
> >>  // KEY_PROG2 press/release repeats every 0.5 secs while button held
> >>  KEY_HOME release
> >>
> >> At minimum I'd think we'd want to only send a single PROG2 press/release
> >> for button hold. My thought was that you'd only want to get the code for
> >> 0xe4 or 0xea, not both, but I suppose that's debatable.
> >
> > If you keep a keyboard key pressed, you want multiple events, not one right ?
> > I think it's important not to loose informations. If someone keep this
> > key pressed more than 1.5 second, I think it's good idea to send
> > multiple KEY_PROG2.
> >
> > About KEY_HOME press / release, and filtering KEY_HOME after
> > KEY_PROG2, I'm not sure. So if you really want it, and nobody
> > complains, I'll be happy to accept your patch.
> 
> Here is how I envision using these keys.  I wanted to map quick press
> to GNOME3/KDE4/Unity's Activities menu and map press-and-hold to
> script that rotates screen.  I like the repeating of rotates but I
> didn't really want a rotate to also force a pop up of the activities
> menu.

I've been experimenting with different keyboards a bit, and I basically
see two different behaviours.

  1. Standard keys and some hotkeys - These tend to send a press event
     followed by a short delay, followed by rapidly-repeating press
     events. I.e. what you normally see when you are typing. For hotkeys
     userspace seems to only act upon the release event.

  2. Some hotkeys only seem to send a single scan code when the key is
     released (this seems to be the case with most of the T101MT
     hotkeys). In these cases the drivers send a press followed
     immediately by a release.

So I'm starting to think that the most natural way to handle this is to
treat it as a single key with a couple of special flags (bit 3 = repeat
event and bit 0 = release event). I.e. we only send on keycode and the
filter code just clears the flag bits, clears autorelease, and decides
whether to send a press or release, if (code & ~0x09) == 0xe4. Then
userspace could map seperate events on press and hold if desired.

In any case I don't think multiple repeat events while the button is
held is the right thing to do.

> >> And back to the question of KEY_HOME -- that's not really what you want,
> >> is it? As in "move cursor to start of line"?
> >
> > Ho .. right, that's what mean KEY_HOME :/. So no, I don't want that...
> > What about:
> > - KEY_CYCLEWINDOWS
> > - KEY_COMPUTER
> > - KEY_HOMEPAGE
> > - KEY_DASHBOARD
> >
> > I think KEY_HOMEPAGE is the best choice.
> 
> I've only had limited time to look more.  So far, I found under udev a
> toshiba tablet that maps what is probably a rotate button to
> KEY_DIRECTION so thats one option for it instead of KEY_PROG2.  I
> couldn't find anybody using that though.
> 
> I see in /usr/share/X11/symbols/inet:
> 
>     key <I162>   {      [ XF86RotateWindows     ]       };
> 
> and in /usr/share/X11/xkb/symbols/evdev:
> 
> xkb/keycodes/evdev:     <I162> = 162;   // #define KEY_CYCLEWINDOWS        154
> 
> Looks like KEY_CYCLEWINDOWS is already hooked up to
> gnome-settings-daemon to auto-rotate screen?
> 
> I ran into total dead end for finding a pre-existing example of home
> button usage.  I'm really surprised we do not yet have a KEY_LAUNCHER
> or similar because so many tablet PCs/smartphones/pads do have a
> button with this specific concept of "bring up your icon based
> application launcher".

That seems to map well onto the idea of the Windows button, which iirc
maps to KEY_LEFTMETA or KEY_RIGHMETA.

> 
> To add to your list, I'll also throw out:
> 
> - KEY_MENU
> - KEY_EXIT (smartphones sometime mean this)
> - KEY_PROG3 (basically all that Windows is doing)
> - KEY_LAUNCHER (why not be the first to finally create it!)
> 
> I vote for either KEY_PROG3 or KEY_HOMEPAGE for at least short term.
> 
> Chris
> 
