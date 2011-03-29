Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1C2M3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 08:29:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49120 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1C2M3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 08:29:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EQS1t63uBlFVqbx3V4fKakcElG7a+TCZSYYOQzSMGx9Djl6a+h01AeWsAxSUHGSH0z
         F6Vx07pUNE/Yegjb9YZ58q+5PI7SA7aVdURWNKzGzB24RXozprP1715Y50Zfyd0Pw07D
         +a6LQZC/8ulN9991twVKifELEOH2MYUKDs79s=
MIME-Version: 1.0
In-Reply-To: <1301337224-3293-3-git-send-email-seth.forshee@canonical.com>
References: <AANLkTi=U2Qkqv7FKfe18f0a=8Xg0QwRX_cxFj-j7ZPC=@mail.gmail.com>
	<1301337224-3293-1-git-send-email-seth.forshee@canonical.com>
	<1301337224-3293-3-git-send-email-seth.forshee@canonical.com>
Date: Tue, 29 Mar 2011 12:29:11 +0000
Message-ID: <AANLkTi=QJzVt=tR2mUmaRwvhNz5eeV0BE1LB0-pCybNV@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] eeepc-wmi: Add support for T101MT Home/Express
 Gate key
From: Corentin Chary <corentin.chary@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 6:33 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> This key is different than other hotkeys, having seperate scan
> codes for press, release, and hold, so it requires some special
> filtering. Press and release events are passed on, and hold events
> are ignored since sparse-keymap does not support hardware
> autorepeat.
>
> Note that "Home" in the context of this button doesn't mean the
> same thing as the usual Home key, and it really isn't clear at
> all what is meant by "Home". The manufacurer's description of the
> button indicates that it should launch some sort of touch screen
> settings interface on short press and apply a desktop rotation on
> long press.
>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/platform/x86/eeepc-wmi.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
> index 0ddc434..8f3112d5 100644
> --- a/drivers/platform/x86/eeepc-wmi.c
> +++ b/drivers/platform/x86/eeepc-wmi.c
> @@ -56,6 +56,11 @@ MODULE_PARM_DESC(hotplug_wireless,
>                 "If your laptop needs that, please report to "
>                 "acpi4asus-user@lists.sourceforge.net.");
>
> +/* Values for T101MT "Home" key */
> +#define HOME_PRESS     0xe4
> +#define HOME_HOLD      0xea
> +#define HOME_RELEASE   0xe5
> +
>  static const struct key_entry eeepc_wmi_keymap[] = {
>        /* Sleep already handled via generic ACPI code */
>        { KE_KEY, 0x30, { KEY_VOLUMEUP } },
> @@ -70,6 +75,7 @@ static const struct key_entry eeepc_wmi_keymap[] = {
>        { KE_KEY, 0xcc, { KEY_SWITCHVIDEOMODE } },
>        { KE_KEY, 0xe0, { KEY_PROG1 } }, /* Task Manager */
>        { KE_KEY, 0xe1, { KEY_F14 } }, /* Change Resolution */
> +       { KE_KEY, HOME_PRESS, { KEY_CONFIG } },

What X11 key is mapped to KEY_CONFIG ?

>        { KE_KEY, 0xe9, { KEY_BRIGHTNESS_ZERO } },
>        { KE_KEY, 0xeb, { KEY_CAMERA_ZOOMOUT } },
>        { KE_KEY, 0xec, { KEY_CAMERA_UP } },
> @@ -79,6 +85,25 @@ static const struct key_entry eeepc_wmi_keymap[] = {
>        { KE_END, 0},
>  };
>
> +static void eeepc_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int *code,
> +                                unsigned int *value, bool *autorelease)
> +{
> +       switch (*code) {
> +       case HOME_PRESS:
> +               *value = 1;
> +               *autorelease = 0;
> +               break;
> +       case HOME_HOLD:
> +               *code = ASUS_WMI_KEY_IGNORE;
> +               break;
> +       case HOME_RELEASE:
> +               *code = HOME_PRESS;
> +               *value = 0;
> +               *autorelease = 0;
> +               break;
> +       }
> +}
> +
>  static acpi_status eeepc_wmi_parse_device(acpi_handle handle, u32 level,
>                                                 void *context, void **retval)
>  {
> @@ -149,6 +174,7 @@ static struct asus_wmi_driver asus_wmi_driver = {
>        .keymap = eeepc_wmi_keymap,
>        .input_name = "Eee PC WMI hotkeys",
>        .input_phys = EEEPC_WMI_FILE "/input0",
> +       .key_filter = eeepc_wmi_key_filter,
>        .probe = eeepc_wmi_probe,
>        .quirks = eeepc_wmi_quirks,
>  };
> --
> 1.7.4.1
>
>

I think this version is ok,

Matthew, do you think this should be delayed for 2.6.40 (merge window
will close soon, so now it's probably time for fix only) ?

-- 
Corentin Chary
http://xf.iksaif.net
