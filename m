Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1CYN2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:28:34 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34262 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab1CYN2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:28:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mLYVpcuxpOYOzaWGxjWf3Nc1VbY4Ctk2rSmaMxfIo+hYMO+WuDmYwPyFOrTn88T0xU
         zjuBDLBPrxvf4p6lK/laqGoKDZHw4WG9YfC/552+xsRECFbaEFygLNnPUYrSe4RwUDaw
         +tgQE/IxAK/Mg5Y3rHGLJSEl0Da2/S3AoGtp0=
MIME-Version: 1.0
In-Reply-To: <1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
References: <20110324195720.GB31713@thinkpad-t410>
	<1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
Date: Fri, 25 Mar 2011 13:28:30 +0000
Message-ID: <AANLkTimF2UR8BVQW-3YJaGFEz39q8ydESAiMOjmdM1X7@mail.gmail.com>
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate key
From: Corentin Chary <corentin.chary@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2PDSpJJ025925

> +static void eeepc_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int *code,
> +                                int *value, int *autorelease)
> +{
> +       struct eeepc_wmi_driver *eeepc = to_eeepc_wmi_driver(asus_wmi);
> +       int is_press;
> +
> +       /*
> +        * The following behavior is used for T101MT "Home" key:
> +        *
> +        *   On press:   No event set
> +        *   On hold:    KEY_PROG2 press sent once w/o autorelease
> +        *   On release: If key was held, KEY_PROG2 release sent.
> +        *               Otherwise KEY_HOME press sent w/ autorelease.
> +        *
> +        * The simple state machine below implements this behavior.
> +        */
> +       switch (*code) {
> +       case HOME_PRESS:
> +               eeepc->home_key_state = HOME_PRESS;
> +               *code = ASUS_WMI_KEY_IGNORE;
> +               break;
> +       case HOME_HOLD:
> +               if (eeepc->home_key_state == HOME_HOLD) {
> +                       *code = ASUS_WMI_KEY_IGNORE;
> +               } else {
> +                       eeepc->home_key_state = HOME_HOLD;
> +                       *value = 1;
> +                       *autorelease = 0;
> +               }
> +               break;
> +       case HOME_RELEASE:
> +               if (eeepc->home_key_state == HOME_RELEASE) {
> +                       dev_warn(&asus_wmi->platform_device->dev,
> +                                "Unexpected home key release event\n");
> +                       *code = ASUS_WMI_KEY_IGNORE;
> +               } else {
> +                       *code = eeepc->home_key_state;
> +                       eeepc->home_key_state = HOME_RELEASE;
> +                       is_press = (*code == HOME_PRESS);
> +                       *value = is_press;
> +                       *autorelease = is_press;
> +               }
> +               break;
> +       }
> +}
> +

Why not something simpler like this ?

static void eeepc_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int code,
                                                 int *value, int *autorelease)
{
        if (code == 0xe4) {
                *value = 1;
                *autorelease = 0;
        } else if (code == 0xe5) {
                *value = 0;
                *autorelease = 0;
       }
}

with this keymap :

       { KE_KEY, 0xe4, { KEY_HOME } }, /* Home Key Down */
       { KE_KEY, 0xe5, { KEY_HOME } }, /* Home Key Up */
       { KE_KEY, 0xea, { KEY_PROG2 } }, /* Home Key hold more than one second */


This sounds simpler and we don't loose information (key down and key
up both event reported at the right time).
0xe5 is *always* sent after 0xe4 right ?

Also, for the callback, "value" should be an unsigned int, and
"autorelease" a bool.

Thanks,
-- 
Corentin Chary
http://xf.iksaif.net
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
