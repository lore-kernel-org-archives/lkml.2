Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2LRWK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:10:58 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45714 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab2LRWK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:10:56 -0500
MIME-Version: 1.0
In-Reply-To: <20121218220223.5ae69bf0@pyramind.ukuu.org.uk>
References: <20121218210449.GA3329@www.outflux.net>
	<20121218220223.5ae69bf0@pyramind.ukuu.org.uk>
Date: Tue, 18 Dec 2012 14:10:56 -0800
X-Google-Sender-Auth: lRXfTai_y5TqeNDnNLEtu1HDtac
Message-ID: <CAGXu5jKZ5YFsiyh2E0pT8xnNKKrdj7o90TnsC4yA-WCCK1Hmrg@mail.gmail.com>
Subject: Re: [PATCH v2] firmware: make sure paths remain relative
From: Kees Cook <keescook@chromium.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 2:02 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 18 Dec 2012 13:04:49 -0800
> Kees Cook <keescook@chromium.org> wrote:
>
>> Some devices have configurable firmware locations. If these configuration
>> mechanisms are exposed to unprivileged userspace, it may be possible to
>> load firmware from an unexpected location. To minimize the risk of this,
>> make sure the string "../" does not appear in the firmware name. This
>> means that neither the users of request_firmware, nor the uevent handler
>> have to do this filtering themselves.
>
> Have you verified no existing distribution ever does this ?

As far as I've found, the only non-static firmware loader I've found
is on Chrome OS.

>> +     if (strstr(name, "../")) {
>
> and this is obviously buggy and hasn't been tested
>
> Hint foo/bar../baz
>
> You need to check for ^../ /../ and /..$

The distros that handle the firmware uevent all prepend the string
"/lib/firmware/".

/lib/firmware/ + "../anything" will leave the directory.
/lib/firmware/ + "anything/../anything" can potentially leave the directory.
/lib/firmware/ + "anything/.." can potentially leave the directory,
but does not refer to a file.

Only "../" needs to be filtered. Given what a tiny corner-case this is
(non-root-control over the firmware filename path), I feel it is
sufficient.

The alternative is for the uevent handler to do this filtering, but it
seemed more sensible to have the kernel not feed it a crazy string in
the first place.

-Kees

--
Kees Cook
Chrome OS Security
