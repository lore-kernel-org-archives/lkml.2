Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab2DMJVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:21:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34870 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026Ab2DMJVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:21:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120413091147.GA3923@polaris.bitmath.org>
References: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
 <1333039766-8617-12-git-send-email-djkurtz@chromium.org> <20120413091147.GA3923@polaris.bitmath.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 13 Apr 2012 17:21:13 +0800
X-Google-Sender-Auth: TCMlQVb9SVAe6TgYY97z3y9xa6k
Message-ID: <CAGS+omD5WxL4mrt8Czw7M3OAbuBH2CVO-EmFmhG3VucSNRuLCw@mail.gmail.com>
Subject: Re: [PATCH 11/16 v2] Input: atmel_mxt_ts - refactor reading object table
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 5:11 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Daniel,
>
>> Instead of reading each object separately, fetch the whole table in one
>> large i2c transaction.  A 6 byte table object requires 10 bytes to read,
>> so doing this dramatically reduces overhead.
>>
>> Also, as a cleanup, move object_table allocation (and post-fw-update
>> reallocation) into mxt_get_object_table().
>>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>> ---
>>  drivers/input/touchscreen/atmel_mxt_ts.c |   66 +++++++++++++++---------------
>>  1 files changed, 33 insertions(+), 33 deletions(-)
>>
>> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
>> index 9d88faf..0d0dab6 100644
>> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
>> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
>> @@ -437,14 +437,7 @@ static int mxt_write_reg(struct i2c_client *client, u16 reg, u16 len,
>>       return 0;
>>  }
>>
>> -static int mxt_read_object_table(struct i2c_client *client,
>> -                                   u16 reg, u8 *object_buf)
>> -{
>> -     return mxt_read_reg(client, reg, MXT_OBJECT_SIZE, object_buf);
>> -}
>> -
>> -static struct mxt_object *
>> -mxt_get_object(struct mxt_data *data, u8 type)
>> +static struct mxt_object *mxt_get_object(struct mxt_data *data, u8 type)
>>  {
>>       struct mxt_object *object;
>>       int i;
>> @@ -733,25 +726,41 @@ static void mxt_handle_pdata(struct mxt_data *data)
>>
>>  static int mxt_get_object_table(struct mxt_data *data)
>>  {
>> +     struct i2c_client *client = data->client;
>> +     struct device *dev = &client->dev;
>>       int error;
>>       int i;
>> -     u16 reg;
>>       u8 reportid = 0;
>> -     u8 buf[MXT_OBJECT_SIZE];
>> +     u8 *buf;
>> +     size_t buf_size;
>>
>> -     for (i = 0; i < data->info.object_num; i++) {
>> -             struct mxt_object *object = data->object_table + i;
>> +     /* Free old object table, if there was one. */
>> +     kfree(data->object_table);
>> +     data->object_table = kcalloc(data->info.object_num,
>> +                                  sizeof(struct mxt_object), GFP_KERNEL);
>> +     if (!data->object_table) {
>> +             dev_err(dev, "Failed to allocate object table\n");
>> +             return -ENOMEM;
>> +     }
>>
>> -             reg = MXT_OBJECT_START + MXT_OBJECT_SIZE * i;
>> -             error = mxt_read_object_table(data->client, reg, buf);
>> -             if (error)
>> -                     return error;
>> +     buf_size = MXT_OBJECT_SIZE * data->info.object_num;
>> +     buf = kmalloc(buf_size, GFP_KERNEL);
>> +     if (!buf)
>> +             return -ENOMEM;
>>
>> -             object->type = buf[0];
>> -             object->start_address = (buf[2] << 8) | buf[1];
>> -             object->size = buf[3] + 1;
>> -             object->instances = buf[4] + 1;
>> -             object->num_report_ids = buf[5];
>> +     error = mxt_read_reg(client, MXT_OBJECT_START, buf_size, buf);
>> +     if (error)
>> +             goto done;
>> +
>> +     for (i = 0; i < data->info.object_num; i++) {
>> +             struct mxt_object *object = &data->object_table[i];
>> +             u8 *obj_buf = &buf[i * MXT_OBJECT_SIZE];
>> +
>> +             object->type = obj_buf[0];
>> +             object->start_address = (obj_buf[2] << 8) | obj_buf[1];
>> +             object->size = obj_buf[3] + 1;
>> +             object->instances = obj_buf[4] + 1;
>> +             object->num_report_ids = obj_buf[5];
>
> Putting this conversion in a function would be nice, it would also
> make it clear that the inverse, used for writing, is currently
> missing. Alternatively, how about making the object struct actually
> match the read data? To top it off, one could introduce a collection,
> prepending the buffer size, making the write operation trivial.

AFAIK, there is no corresponding "object table" write. The "object
table" (maybe more aptly named the "object descriptor table") is an
immutable blob read from firmware that describes some actual data
objects elsewhere in device memory.  It is those actual objects that
are writable.  When they are written, it is the actual size, location
and number of instances (not their raw '-1' values) that is useful.

Thanks,
-Daniel

>
> struct mxt_raw_object {
>        u8 type;
>        __le16 start_address_le;
>        u8 size_minus_one;
>        u8 instances_minus_one;
>        u8 num_report_ids;
> };
>
> struct mxt_raw_object_collection {
>       __le16 total_bytes_le;
>       struct mxt_raw_object instance[MAX_NUM_OBJECTS];
> };
>
>>
>>               if (object->num_report_ids) {
>>                       reportid += object->num_report_ids * object->instances;
>> @@ -759,7 +768,9 @@ static int mxt_get_object_table(struct mxt_data *data)
>>               }
>>       }
>>
>> -     return 0;
>> +done:
>> +     kfree(buf);
>> +     return error;
>>  }
>>
>>  static int mxt_initialize(struct mxt_data *data)
>> @@ -774,14 +785,6 @@ static int mxt_initialize(struct mxt_data *data)
>>       if (error)
>>               return error;
>>
>> -     data->object_table = kcalloc(info->object_num,
>> -                                  sizeof(struct mxt_object),
>> -                                  GFP_KERNEL);
>> -     if (!data->object_table) {
>> -             dev_err(&client->dev, "Failed to allocate memory\n");
>> -             return -ENOMEM;
>> -     }
>> -
>>       /* Get object table information */
>>       error = mxt_get_object_table(data);
>>       if (error)
>> @@ -971,9 +974,6 @@ static ssize_t mxt_update_fw_store(struct device *dev,
>>               /* Wait for reset */
>>               msleep(MXT_FWRESET_TIME);
>>
>> -             kfree(data->object_table);
>> -             data->object_table = NULL;
>> -
>>               mxt_initialize(data);
>>       }
>>
>> --
>> 1.7.7.3
>>
>
> Thanks,
> Henrik
