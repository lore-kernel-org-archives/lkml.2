Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750923Ab0KDECv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 00:02:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57729 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab0KDECt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 00:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vl/WJLgyP1AxEaoF75sHFm7MpHULyesOzuJ7jrj4a5BtSRMepZnkuC0qzsPoLQqw9d
         EQ0+keYaMTgPKyOOFYuU3fmLUWtHU06f8/0VfF6Lvt6y0ZwZjKOAKyJw7CdA9Bt2kMPH
         UZpnubV31+hWYAJPEnfoctlWKyPr1IqGPAOuE=
MIME-Version: 1.0
In-Reply-To: <4CD22627.2000607@redhat.com>
References: <20101009224041.GA901@sepie.suse.cz>
	<4CD1E232.30406@redhat.com>
	<AANLkTimyh-k8gYwuNi6nZFp3oviQ33+M3fDRzZ+sJN9i@mail.gmail.com>
	<4CD22627.2000607@redhat.com>
Date: Thu, 4 Nov 2010 00:02:48 -0400
Message-ID: <AANLkTi=N9pioMusdLCwEzT7dUg02j9QE_ndHs0tBhuiB@mail.gmail.com>
Subject: Re: REGRESSION: Re: [GIT] kconfig rc fixes
From: Arnaud Lacombe <lacombar@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, kyle@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Nov 3, 2010 at 11:19 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>>> config VIDEO_HELPER_CHIPS_AUTO
>>>        bool "Autoselect pertinent encoders/decoders and other helper chips"
>>>
>>> config VIDEO_IVTV
>>>        select VIDEO_WM8739 if VIDEO_HELPER_CHIPS_AUTO
>>>
>>> menu "Encoders/decoders and other helper chips"
>>>        depends on !VIDEO_HELPER_CHIPS_AUTO
>>>
>>> config VIDEO_WM8739
>>>        tristate "Wolfson Microelectronics WM8739 stereo audio ADC"
>>>
>
> I don't see anything wrong on such logic. It is valid in C, and it is also valid
> (and works properly) at Kconfig language.
no, it is not a valid Kconfig language, or at least, you create an
ambiguity in the dependency tree.

> So, the warning is a false positive.
>
no it is not. By saying:

menu "Encoders/decoders and other helper chips"
       depends on !VIDEO_HELPER_CHIPS_AUTO

you create on all the menu's children an implicit dependency,
!VIDEO_HELPER_CHIPS_AUTO. This is something that has ever been there;
from `Documentation/kbuild/kconfig-language.txt':

"
[...]
menu "Network device support"
        depends on NET

config NETDEVICES
        ...
endmenu

All entries within the "menu" ... "endmenu" block become a submenu of
"Network device support". All subentries inherit the dependencies from
the menu entry, e.g. this means the dependency "NET" is added to the
dependency list of the config option NETDEVICES.
"

Thus the warning as you also have:

config VIDEO_IVTV
       select VIDEO_WM8739 if VIDEO_HELPER_CHIPS_AUTO

ie. VIDEO_IVTV selects VIDEO_WM8739 if VIDEO_HELPER_CHIPS_AUTO, but
VIDEO_WM8739 has inherited the !VIDEO_HELPER_CHIPS_AUTO dependency.

Now, if you want my true feeling, this warning should be fatal.

 - Arnaud
