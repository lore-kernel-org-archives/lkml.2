Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1DRBUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 21:20:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64868 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab1DRBUp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 21:20:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=EV/lojIxRRjmK4TiD7COm4XB/Klj/c76sv6s9ar2/LtVm8d28IUJTzdRzeVFNzFOGp
         W/6L/HECJB4qYCXy1m8kMQdVM4aJ3IrI0zuIM7GqnuvrKcuoAE0seDlepPXFXt9ewmn3
         bJT65dN1YvPjMbL24Whb2PuoHqk/J4e7erUD0=
MIME-Version: 1.0
In-Reply-To: <20110417180722.GA21112@hallyn.com>
References: <BANLkTikTxCFHs2xb4b5QFQp3SJAEjgyRJg@mail.gmail.com>
	<20110417180722.GA21112@hallyn.com>
Date: Mon, 18 Apr 2011 10:20:43 +0900
Message-ID: <BANLkTike0=ivQux4-m_5V2GheOkmRE-0ow@mail.gmail.com>
Subject: Re: Linux capabilities shouldn't be lost during setuid to non-root
 from root or to another non-root uid from a non-root uid.
From: crocket <crockabiscuit@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prctl(PR_SET_KEEPCAPS, 1) didn't work since, during setuid to
non-root, effective bit was lost.

Please refer to "man prctl".

I don't know what would happen when I run OpenVPN as non-root with
cap_setuid, cap_setgid, cap_sys_admin.
I guess OpenVPN woull fail to generate tun0 interface if it's run as root.
However, I need to test it to be sure.

On Mon, Apr 18, 2011 at 3:07 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> You need
>
>        prctl(PR_SET_KEEPCAPS, 1);
>
> man prctl for details.  In particular, see the following example:
>
> #include <stdio.h>
> #include <sys/prctl.h>
> #include <sys/capability.h>
>
> int main()
> {
>        cap_t c;
>        c = cap_get_proc();
>        printf("uid %d, current caps: %s\n", getuid(), cap_to_text(c, NULL));
>        cap_free(c);
>        prctl(PR_SET_KEEPCAPS, 1);
>        setuid(1001, 1001, 1001);
>        c = cap_get_proc();
>        printf("uid %d, current caps: %s\n", getuid(), cap_to_text(c, NULL));
>        cap_free(c);
> }
>
> You can either run that as root, or you can do
>
>        sudo setcap cap_setuid,cap_setgid,cap_sys_admin=eip captest
>
> and then run it as non-root.
>
> HTH,
> -serge
>
