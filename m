Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab2BDR0K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 12:26:10 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:44764 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289Ab2BDR0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 12:26:08 -0500
Message-ID: <4F2D6A21.7030903@metafoo.de>
Date: Sat, 04 Feb 2012 18:25:53 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 2/3] apple_bl: Rework in advance of gmux backlight support
References: <1328300884-21551-1-git-send-email-seth.forshee@canonical.com> <1328300884-21551-3-git-send-email-seth.forshee@canonical.com> <4F2C5EC8.8090203@metafoo.de> <20120203225123.GD22758@ubuntu-macmini>
In-Reply-To: <20120203225123.GD22758@ubuntu-macmini>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 11:51 PM, Seth Forshee wrote:
> On Fri, Feb 03, 2012 at 11:25:12PM +0100, Lars-Peter Clausen wrote:
>> On 02/03/2012 09:28 PM, Seth Forshee wrote:
>>> Make it easier to support backlights without a fixed I/O range, and
>>> remove use of global variables to allow having multiple backlights
>>> concurrently.
>>>
>>> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
>>> ---
>>>  drivers/video/backlight/apple_bl.c |  163 +++++++++++++++++++-----------------
>>>  1 files changed, 85 insertions(+), 78 deletions(-)
>>>
>>> diff --git a/drivers/video/backlight/apple_bl.c b/drivers/video/backlight/apple_bl.c
>>> index 66d5bec..e65b459 100644
>>> --- a/drivers/video/backlight/apple_bl.c
>>> +++ b/drivers/video/backlight/apple_bl.c
>>> @@ -27,39 +27,30 @@
>>>  #include <linux/pci.h>
>>>  #include <linux/acpi.h>
>>> [...]
>>> + */
>>> +static int apple_bl_get_brightness(struct backlight_device *bd)
>>> +{
>>> +	struct apple_bl_data *bl_data = bl_get_data(bd);
>>> +	return bl_data->get_brightness(bl_data);
>>> +}
>>> +
>>> +static int apple_bl_update_status(struct backlight_device *bd)
>>> +{
>>> +	struct apple_bl_data *bl_data = bl_get_data(bd);
>>> +
>>> +	bl_data->set_brightness(bl_data, bd->props.brightness);
>>> +	return 0;
>>> +}
>>> +
>>> +static const struct backlight_ops apple_bl_ops = {
>>> +	.get_brightness = apple_bl_get_brightness,
>>> +	.update_status = apple_bl_update_status,
>>>  };
>>
>> Adding this extra indirection here isn't so nice and isn't necessary either.
>> Just define one set of backlight ops for the intel case and one for the nvidia
>> case and use it accordingly when registering the backlight device.
> 
> There's a reason for the extra level of indirection to be there. The
> driver uses {get,set}_brightness before the backlight device has been
> allocated to test whether or not the backlight interface actually works.
> This worked okay previously because the functions didn't need any extra
> data; they just access fixed port addresses (really it only half-worked,
> the update_status actually already has this indirection to support the
> test, duplicated for each interface). But for the gmux backlight we're
> getting the I/O address range from ACPI, so it needs to get at the data.
> 

Ok, I see. Btw. am I missing something or are the intel and nvidia
{set,get}_brightness functions identical except for the IO base address? If
yes, I think they could be merged since you now pass the pass base address into
the function when calling it.

Something that would also be good to fix is to move the request_region(...) on
the IO address before actually accessing it.

> Of course there are a couple of ways we could get around this. Not
> calling the backlight ops in the gmux case would be an option; then you
> don't get the check, but so far as I know right now the check doesn't
> work for the gmux backlight anyway. Or allocating the backlight device
> first before doing the check, but I don't see that as a good option.
> 

Hm, if that the check doesn't do anything for gmux is there acutally any code
shared between the gmux and the legacy path in the driver? If not would make
sense to put the gmux backlight support into its own driver?

- Lars

