Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab2AAWpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 17:45:22 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:41874 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069Ab2AAWpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 17:45:19 -0500
X-Sasl-enc: JlxDT84g59UwvhesSxXqAu7FVXctEFV+KyUhaX8xsTr5 1325457918
Message-ID: <4F00E1FB.9060507@fastmail.fm>
Date: Sun, 01 Jan 2012 22:45:15 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Matthew Garrett <mjg@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
References: <20111230235421.GA6054@redhat.com> <CA+55aFyqm4FbW=--7U4ULk1EBb6RLP0sRgtokODBYnZNiJXWew@mail.gmail.com>
In-Reply-To: <CA+55aFyqm4FbW=--7U4ULk1EBb6RLP0sRgtokODBYnZNiJXWew@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/12/11 00:22, Linus Torvalds wrote:
> It's also possible that we should blame the firmware code, which is
> expressly written to encourage these kinds of bugs. It may be that i
> tshould be the firmware code that has a "get_firmware()" +
> "put_firmware()" model, and it should cache the firmware explicitly if
> the config supports suspend, so that a firmware read at resume time
> would actually work. The whole "request_firmware()" interface really
> is very prone to these kinds of bugs.

How about these semantics for get_firmware / put_firmware:

get_firmware -> checks for a cached copy of the firmware and returns
that if it exists otherwise calls _get_firmware (i.e.
_request_firmware). Either way we get a refcount to the firmware blob.
This requires adding 3 members to struct firmware: the refcount, the
name of the firmware (see @name in request_firmware) and a list head to
cache with. We could also add and async version of this to match
request_firmware_nowait.

put_firmware -> Removes a refcount from the firmware and frees if there
are no more users.

put_firmware is called when we are sure that we no longer need to reload
the firmware for that device - device close time for most drivers.

USB is a more difficult case as devices can change ID but the firmware
blob still needs to be associated with them. I don't know USB at all so
I have no idea if we can track this. Some PCI devices may also suffer
the same problem.

Hope this is useful,

Jack
