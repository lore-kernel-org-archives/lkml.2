Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab3ADOMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 09:12:25 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55567 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738Ab3ADOMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 09:12:20 -0500
Message-ID: <50E6E322.8070108@imgtec.com>
Date: Fri, 4 Jan 2013 14:11:46 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 43/44] tty/metag_da: Add metag DA TTY driver
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com> <1354723742-6195-44-git-send-email-james.hogan@imgtec.com> <20121205172446.41aa464e@pyramind.ukuu.org.uk>
In-Reply-To: <20121205172446.41aa464e@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_04_14_11_47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thanks for your feedback, and sorry for the delay responding. I'll send
an updated (i.e. largely rewritten) driver soon.

On 05/12/12 17:24, Alan Cox wrote:
>> +/* One struct dashtty exists per open channel. */
>> +struct dashtty {
>> +	struct tty_struct *tty;
>> +	struct tty_port *port;
>> +};
> 
> We have tty->port as of 3.7 so you shouldn't need this any more

Thanks, I've converted the driver to make use of this

> 
>> +
>> +static struct tty_port dashtty_ports[NUM_TTY_CHANNELS];
>> +
>> +struct dashbuf {
>> +	struct list_head entry;
>> +	struct dashtty *tty;
>> +	unsigned char *buf;
>> +	int count;
>> +	int chan;
>> +};
> 
>> +/*
>> + * Attempts to fetch count bytes from channel channel and returns actual count.
>> + */
>> +static int fetch_data(int channel)
>> +{
>> +	struct dashtty *dashtty = dashtty_ttys[channel];
> 
> krefs for the tty ?, what if the tty is closing at the same moment ?

Thanks, I've fixed that now.

> 
>> +
>> +static int put_data(void *arg)
>> +{
>> +	struct dashbuf *dbuf;
>> +	int number_written;
>> +
>> +	__set_current_state(TASK_RUNNING);
>> +	while (!kthread_should_stop()) {
>> +		/*
>> +		 * Pick up all the output buffers and write them out.
>> +		 *
>> +		 * FIXME: should we check with ASE how much room we have?
>> +		 * Ideally, this will already have been done by write_room ??
>> +		 */
> 
> 
> No because your writer is asynchronous to your query so you need to
> manage the difference yourself. You also need to get it right on the
> queue length for close to work right.

Regarding closing working right, do you mean making sure that all data
in the asynchronous output buffer is written out by the final close
(e.g. port_shutdown before freeing it)? Is that something the driver
needs to do itself? (at the moment it does seem to be necessary, however
I could be missing something)

> 
>> +
>> +/*
>> + *	This gets called every DA_TTY_POLL and polls the channels for data
>> + */
>> +static void dashtty_timer(unsigned long ignored)
>> +{
>> +	struct dashtty *dtty;
>> +	int this_channel;
>> +
>> +	/* If there are no ports open do nothing and don't poll again. */
> 
> Why are we polling - is this just an architectural limit ?

Yes, the only way to know whether the debugger has written anything to
the buffer in the debug pod is to ask it, hence the polling. Actually
it's more like halt the hardware thread with a SWITCH instruction and
wait patiently for the DA to notice and to handle it.

> 
>> +}
>> +
>> +static int dashtty_open(struct tty_struct *tty, struct file *filp)
>> +{
>> +	struct dashtty *dashtty;
> 
> No - use the full helpers - your sematics are wrong otherwise.

I presume you're referring to tty_port_open. I've converted to use that now.

> 
>> +static void dashtty_close(struct tty_struct *tty, struct file *filp)
> 
> No.. we have helpers - use them.
> 
>> +	if (num_channels_need_poll <= 0)
>> +		del_timer(&poll_timer);
> 
> _sync 
> 
> This seems to be a repeated error so it may be worth checking your other
> drivers.

Ok

>> +}
>> +
>> +static int dashtty_write(struct tty_struct *tty, const unsigned char *buf,
>> +			 int count)
>> +{
>> +	struct dashtty *dtty;
>> +	struct dashbuf *dbuf;
>> +	int channel;
>> +
>> +	if (count <= 0)
>> +		return 0;
> 
> How can it be <= 0 ?

It probably can't. I've removed it now (and the new version is safe even
if it was 0 anyway).

> 
>> +	/* Determine the channel */
>> +	channel = FIRST_TTY_CHANNEL + tty->index;
>> +	dtty = dashtty_ttys[channel];
>> +	BUG_ON(!dtty);
> 
> What is your locking model to prevent this ?
> What is your reference counting model for the ttys - I don't see one.

The new version has an array of dashtty_ports (not pointers, each
containing a tty_port) and uses that to get at the output buffer.

Would it need to ensure that the tty isn't hung up though, or is a write
prevented from occurring in that case?

> 
>> +
>> +	dbuf = kzalloc(sizeof(*dbuf), GFP_KERNEL);
>> +	if (!dbuf)
>> +		return 0;
>> +
>> +	dbuf->buf = kzalloc(count, GFP_KERNEL);
>> +	if (!dbuf->buf) {
>> +		kfree(dbuf);
>> +		return 0;
>> +	}
>> +
>> +	memcpy(dbuf->buf, buf, count);
> 
> So you'll spend all your CPU time doing itty bitty allocations. Just
> allocate a buffer at open (there's even a tty_port helper for buffer
> management), free it when you've finished using the port. (and don't
> report > the buffer size is write room)

Agreed and done. I didn't realise the TTY layer was so prone to
providing lots of itty bitty fragments (even with a single 4k write from
userland). The thing that really hurt was not the allocations but that
each one was written out to the DA separately each incurring it's own
large latency. Using a write buffer makes it a lot faster :)

> 
>> +	/*
>> +	 * FIXME: This is slightly optimistic. Because we're deferring
>> +	 * the output until later it is impossible to predict whether we
>> +	 * will actually write "count" bytes.
>> +	 */
>> +	return count;
> 
> Fair enough but is then your chars_in_buffer and write_room methods are
> both wrong (you need to avoid offering space you've queued into).

This is now rewritten so that the deferred write takes note of the
number of bytes written out to the DA and doesn't discard any data. The
chars_in_buffer and write_room methods now return the size/space in the
output buffer.

It's still possible that the debugger isn't draining the DA buffers in
which case they'll fill up, and the output buffer in the driver will
fill and then the space reported to the tty layer will drop to 0.

> 
>> +}
> 
>> +static const struct tty_operations dashtty_ops = {
>> +	.open = dashtty_open,
>> +	.close = dashtty_close,
>> +	.write = dashtty_write,
> 
> You need a hangup method. You may need a termios method.

Is it sufficient for a hangup method to just call tty_port_hangup or
should it drop the contents of the output buffer too? (as opposed to
waiting for it to drain in port_shutdown).

As far as I can tell none of the termios stuff is really relevant to
this driver.

> 
>> +	.write_room = dashtty_write_room,
>> +	.chars_in_buffer = dashtty_chars_in_buffer,
>> +};
>> +
>> +static int __init dashtty_init(void)
>> +{
>> +	int ret;
>> +	int nport;
>> +
>> +	if (!metag_da_enabled())
>> +		return -ENODEV;
>> +
>> +	channel_driver = tty_alloc_driver(NUM_TTY_CHANNELS, 0);
>> +	if (IS_ERR(channel_driver))
>> +		return PTR_ERR(channel_driver);
>> +
>> +	channel_driver->owner = THIS_MODULE;
>> +	channel_driver->driver_name = "ttyDA";
>> +	channel_driver->name = "ttyDA";
>> +	channel_driver->major = DA_TTY_MAJOR;
>> +	channel_driver->minor_start = 0;
>> +	channel_driver->type = TTY_DRIVER_TYPE_SERIAL;
>> +	channel_driver->subtype = SERIAL_TYPE_NORMAL;
>> +	channel_driver->init_termios = tty_std_termios;
>> +	channel_driver->init_termios.c_cflag =
>> +	    B38400 | CS8 | CREAD | HUPCL | CLOCAL;
>> +	channel_driver->flags = TTY_DRIVER_REAL_RAW;
> 
> Need to set the speed flags

Do you mean c_ispeed, and c_ospeed? These are set in tty_std_termios,
and they aren't meaningful in the context of this driver anyway, so are
they still necessary?

> 
>> +static void dashtty_exit(void)
>> +{
>> +	kthread_stop(dashtty_thread);
>> +	del_timer(&poll_timer);
> 
> 
> del_timer_sync or your box will sometimes crash on exit as the timer is
> still running on another thread
> 

Thanks again for taking the time to review it

James

