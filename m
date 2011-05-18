Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab1ERPCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:02:34 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:53756 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933260Ab1ERPCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:02:32 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DD3E02C.4030502@cam.ac.uk>
Date: Wed, 18 May 2011 16:05:16 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.drivers.sensors
CC: fabien.marteau@armadeus.com, khali@linux-fr.org,
        guenter.roeck@ericsson.com, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: Driver for as1531, Austria-Microsystem Analog
 to Digital Converter.
References: <fabien.marteau@armadeus.com> <1305553154-18195-2-git-send-email-fabien.marteau@armadeus.com> <4DD3C4F9.2000806@cam.ac.uk>
In-Reply-To: <4DD3C4F9.2000806@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/11 14:09, Jonathan Cameron wrote:
> On 05/16/11 14:39, fabien.marteau@armadeus.com wrote:
>> From: Fabien Marteau <fabien.marteau@armadeus.com>
>>
> Had a few minutes so done a quick port to IIO with minimal code changes.
> Now looking at cleaning things up so actually reading the code rather
> than cut and paste.  The message is somewhat 'novel'. 
> 
> ...
> 
> So we have a spi device that only talks in 1 bit words?
> 1) I'm amazed any spi controllers support that.
> 2) Doesn't look necessary from the data sheet google furnished me with.
> 
> Looks like it will quite happily work with 8 bit transfers. Suggested replacement code below.
>> +static int as1531_message(struct spi_device *spi, int cmd, int *ret_value)
>> +{
>> +	struct spi_message	message;
>> +	struct spi_transfer	x[1];
>> +	int status, i;
>> +	u8	cmd_send;
>> +	unsigned char buf[64];
>> +	unsigned char buf_read[64];
>> +
>> +	cmd_send = cmd;
>> +
>> +	spi_message_init(&message);
>> +	memset(x, 0, sizeof x);
>> +	memset(buf, 0, sizeof(buf));
>> +	memset(buf_read, 0, sizeof(buf_read));
>> +
>> +	for (i = 0; i < 8; i++) {
>> +		buf[i] = ((cmd_send & 0x80)>>7);
>> +		cmd_send = cmd_send << 1;
>> +	}
>> +
>> +	x[0].tx_buf = buf;
>> +	x[0].len = 24;
>> +	x[0].rx_buf = buf_read;
>> +	x[0].speed_hz = AS1531_SPI_SPEED;
>> +	x[0].bits_per_word = 1;
>> +	spi_message_add_tail(&x[0], &message);
>> +
>> +	status = spi_sync(spi, &message);
>> +	if (status < 0)
>> +		return status;
>> +
>> +	*ret_value = buf_read[11] & 0x01;
>> +	for (i = 12; i < 23 ; i++) {
>> +		*ret_value = *ret_value << 1;
>> +		*ret_value = *ret_value | (buf_read[i]&0x01);
>> +	}
>> +
>> +	return 0;
>> +}

Or skip the below and use spi_w8r16. This isn't a fast capture route anyway.
> static int as1531_message(struct spi_device *spi, int cmd, u16 *ret_value)
> {
> 	int status;
> 	u8 cmd_send = cmd;
> 	struct spi_message message;
> 	struct spi_transfer x[2] = {
> 		{
> 			.len = 1,
> 			/* this should be default anyway - so could drop */
> 			.bits_per_word = 8,
> 			/* This should be set in board config really */
> 			.speed_hz = AS1531_SPI_SPEED,
> 			.rx_buf = &cmd_send,
> 		}, {
> 			.len = 2,
> 			.bits_per_word = 8,
> 			.speed_hz = AS1531_SPI_SPEED,
> 			.tx_buf = ret_value,
> 		}
> 	};
> 
> 	spi_message_init(&message);
> 	spi_message_add_tail(&x[0], &message);
> 	spi_message_add_tail(&x[1], &message);
> 
> 	status = spi_sync(spi, &message);
> 	if (status < 0)
> 		return status;
> 
> 	*ret_value = (be16_to_cpup(ret_value) >> 2) & 0xFFF;
> 
> 	return 0;
> }
> 
> Obviously also requires changing the type of the element passed
> as ret_value.  Could set the bits_per_word of the second transfer
> to 16 and avoid the endianness conversion, but I'm not sure how
> many spi masters support that.
> 
> Jonathan

